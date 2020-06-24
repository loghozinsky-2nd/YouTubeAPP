//
//  APIService.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 22.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import Alamofire

typealias JsonDictionary = [String : Any]
typealias SessionManagerDictionary = [String : Session]

enum Response {
    case success(response: String)
    case failure(error: Error)
    case notConnectedToInternet
}

private protocol APIServiceDelegate: class {
    var dataRequestArray: [DataRequest] { get set }
    var sessionManager: SessionManagerDictionary { get set }
    
    func callEndPoint(_ url: String, method: Alamofire.HTTPMethod, params: JsonDictionary, headers: HTTPHeaders, completion: @escaping (Response) -> Void)
    func serializeResponse(response: AFDataResponse<String>,  completion: @escaping (Response) -> Void)
    func cancelAllRequests()
    
    func success(response: String?, headers: [AnyHashable: Any], completion: @escaping (Response) -> Void)
    func failure(error: Error?, completion: @escaping (Response) -> Void)
    func notConnectedToInternet(completion: @escaping (Response) -> Void)
}

private protocol APIServiceFormatter {
    func getUrlString(api: API, endPoint: EndPoint) -> String
    func getUrlString(_ dict: JsonDictionary, api: API, endPoint: EndPoint) -> String
}

class APIService: APIServiceDelegate, APIServiceFormatter {
    
    static let shared = APIService()
    
    private let token = "AIzaSyCTEpNKPLKcrXF7o3196zSJ2hflCSk21Bk"
    
    private lazy var headers: HTTPHeaders = {
        var dict: HTTPHeaders = [:]
        
        let authorizationKey = "Authorization"
        let authorization = "Bearer " + token
        
        return dict
    }()

    
    private let decoder = JSONDecoder()
    
    fileprivate var dataRequestArray: [DataRequest] = []
    fileprivate var sessionManager: SessionManagerDictionary = [:]
    
    private init() {}
    
    // MARK: - YouTube
    public func getChannelPlaylists(part: String, channelId: String, maxResults: String?, completion: @escaping (ChannelPlaylistResponse) -> Void) {
        var dict: JsonDictionary = ["part" : part, "channelId" : channelId, "key" : token]
        
        if let maxResults = maxResults {
            dict["maxResults"] = maxResults
        }
        
        let url = getUrlString(dict, api: .main, endPoint: .playlists)
        
        callEndPoint(url, headers: self.headers) { [weak self] (response) in
            switch response {
                case .success(let result):
                    let json: String = result
                    do {
                        guard let strongSelf = self else { return }
                        print(result)
                        let data = try strongSelf.decoder.decode(ChannelPlaylistResponse.self, from: Data(json.utf8))

                        print(">> PlaylistResponse as: \(data)")
                        completion(data)
                    } catch {
                        print(error.localizedDescription)
                }
                case .failure(let error):
                    print(">> response Error from failure")
                    print(error)
                default:
                    print(">> response Error from default state")
                    break
            }
        }
    }

    public func getPlaylistItems(part: String, playlistId: String, maxResults: String?, completion: @escaping (PlaylistItemsResponse) -> Void) {
        var dict: JsonDictionary = ["part" : part, "playlistId" : playlistId, "key" : token]
        
        if let maxResults = maxResults {
            dict["maxResults"] = maxResults
        }
        
        let url = getUrlString(dict, api: .main, endPoint: .playlistItems)
        
        callEndPoint(url, headers: self.headers) { [weak self] (response) in
            switch response {
                case .success(let result):
                    let json: String = result
                    do {
                        guard let strongSelf = self else { return }
                        print(result)
                        let data = try strongSelf.decoder.decode(PlaylistItemsResponse.self, from: Data(json.utf8))

                        print(">> PlaylistResponse as: \(data)")
                        completion(data)
                    } catch {
                        print(error.localizedDescription)
                }
                case .failure(let error):
                    print(">> response Error from failure")
                    print(error)
                default:
                    print(">> response Error from default state")
                    break
            }
        }
    }
}

extension APIServiceFormatter {
    
    // MARK: - Format
    func getUrlString(api: API, endPoint: EndPoint) -> String {
        let result: String = api.rawValue + endPoint.rawValue
        
        return result
    }
    
    func getUrlString(_ dict: JsonDictionary, api: API, endPoint: EndPoint) -> String {
        var result = api.rawValue + endPoint.rawValue
        let finalString = dict.description.replacingOccurrences(of: ":", with: "=", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "[", with: "", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: ",", with: "&", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "]", with: "", options: NSString.CompareOptions.literal, range: nil)
        let endPointExtension: String = "?" + finalString
        result += endPointExtension
        
        return result
    }
    
}

extension APIServiceDelegate {
    
    // MARK: - Request API logic
    func callEndPoint(_ url: String, method: Alamofire.HTTPMethod = .get, params: JsonDictionary = [:], headers: HTTPHeaders = [:], completion: @escaping (Response) -> Void) {
        AF.request(url, method: method, parameters: params, headers: headers) { urlRequest in
            print(">> Request on API .\(method.rawValue.lowercased()): \(url)")
        print(">> with params: \(params)")
        print(">> and header: \(headers)")

            urlRequest.timeoutInterval = 5
        }.responseString { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.serializeResponse(response: response, completion: completion)
            strongSelf.sessionManager.removeValue(forKey: url)
        }
    }
    
    func serializeResponse(response: AFDataResponse<String>,  completion: @escaping (Response) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            guard let urlResponse = response.response else {
                if let error = response.error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                    strongSelf.notConnectedToInternet(completion: completion)
                } else {
                    strongSelf.failure(error: response.error, completion: completion)
                }
                return
            }
            
            strongSelf.success(response: response.value, headers: urlResponse.allHeaderFields, completion: completion)
        }
    }
    
    func cancelAllRequests() {
        for dataRequest in self.dataRequestArray {
            dataRequest.cancel()
        }
        
        self.dataRequestArray.removeAll()
    }
    
    func notConnectedToInternet(completion: @escaping (Response) -> Void) {
        completion(.notConnectedToInternet)
    }
    
    func failure(error: Error?, completion: @escaping (Response) -> Void) {
        if let error = error {
            completion(.failure(error: error))
        }
    }
    
    func success(response: String?, headers: [AnyHashable: Any], completion: @escaping (Response) -> Void) {
        if let response = response {
            completion(.success(response: response))
        }
    }
    
}
