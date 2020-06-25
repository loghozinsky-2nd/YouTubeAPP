//
//  BottomSheetPlayerView.swift
//  YouTubeAPP
//
//  Created by iMac_4 on 24.06.2020.
//  Copyright © 2020 Oleksii Oliinyk. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

enum State {
    case fullScreen
    case opened
    case closed
    case hidden
    case disabled
}

class BottomSheetPlayerViewController: UIViewController {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onChangeStateButtonTap), for: .touchUpInside)
        button.setImage(UIImage(named: "Close_Open"), for: .normal)
        
        return button
    }()
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [CGColor.accentColor, CGColor.accentDarkenColor]
        gradientLayer.locations = [0.0, 1.0]
        
        return gradientLayer
    }()
    
    var isOpened = BehaviorRelay<Bool>(value: false)
    var stateOffset: StateOffset!
    
    var visualEffectView: UIVisualEffectView!
    var runningAnimations: [UIViewPropertyAnimator] = []
    var animationProgressWhenInterrupted: CGFloat = 0
    var screen = UIScreen.main.bounds
    var pointInView: CGPoint?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 10, y: screen.height - 74, width: screen.width - 20, height: screen.height)
        
        bindView()
        setupBottomSheet()
        setupLayout(in: closeButton, with: gradientLayer)
    }
    
    private func bindView() {
        isOpened
            .bind { [weak self] (value) in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setupBottomSheet() {
        stateOffset = StateOffset(state: .closed)
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHandleCardTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupLayout(in views: UIView ..., with sublayer: CALayer) {
        view.addSubviews(views)
        
        view.backgroundColor = .accentColor
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        closeButton.anchor(top: view.topAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        
    }
    
}

extension BottomSheetPlayerViewController {
    // MARK: BottomSheet Logic
    private func slide(_ offset: CGFloat = 0, duration: TimeInterval = 0) {
        let offset = screen.height - offset
        
        let toggleBackground = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.view.frame = CGRect(x: 10, y: offset, width: self.screen.width - 20, height: self.view.frame.height)
        }
        
        toggleBackground.startAnimation()
        runningAnimations.append(toggleBackground)
    }
    
    private func getNextState(_ state: State) -> State {
        return state == .closed ? .opened : .closed
    }
    
    
    private func stateOffset(_ offset: CGFloat = 100) -> CGFloat {
        let contentHeight: CGFloat = 300
        switch offset {
        case screen.height / 3 ..< contentHeight + 50:
            let offsetY = screen.height - contentHeight
            self.stateOffset.offset = offsetY
            self.stateOffset.state = .opened
            return offsetY
        default:
            let offsetY = screen.height - 74
            self.stateOffset.offset = offsetY
            self.stateOffset.state = .closed
            return offsetY
        }
    }
    
    // MARK: Handlers
    @objc private func handleCardPan(_ sender: UIPanGestureRecognizer) {
        let superView = self.view.superview!
        let pointInSuperview = sender.location(in: superView)
        let offsetInView = self.pointInView?.y ?? 0
        let offsetY = pointInSuperview.y - offsetInView
        
        switch sender.state {
        case .began:
            print(">> bottomSheet: gesture began")
            let pointInView = sender.location(in: self.view)
            self.pointInView = pointInView
        case .changed:
            print(">> bottomSheet: gesture changed pointInSuperview = \(pointInSuperview.y), offset view in superview = \(offsetY)")
            let toggleBackground = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                self.view.frame = CGRect(x: 10, y: offsetY, width: self.screen.width - 20, height: self.screen.height)
            }
            
            toggleBackground.startAnimation()
            runningAnimations.append(toggleBackground)
        case .ended:
            print(">> bottomSheet: gesture ended")
            print(">> bottomSheet: gesture offsetY = \(offsetY)")
            let offsetReversed = self.screen.height - offsetY
            let rectificationY = stateOffset(offsetReversed)
            let toggleBackground = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                self.view.frame = CGRect(x: 10, y: rectificationY, width: self.screen.width - 20, height: self.screen.height)
            }
            
            toggleBackground.startAnimation()
            runningAnimations.append(toggleBackground)
        default:
            break
        }
    }
    
    @objc private func onChangeStateButtonTap(_ sender: UIButton!) {
        let nextState = getNextState(stateOffset.state)
        stateOffset = .init(state: nextState)
    }
    
    @objc private func onHandleCardTap(recognzier: UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            let nextState = getNextState(stateOffset.state)
            stateOffset = .init(state: nextState)
        default:
            break
        }
    }
}

extension ObservableType {
    func filter(if trigger: Observable<Bool>) -> Observable<Element> {
        withLatestFrom(trigger) { (myValue, triggerValue) -> (Element, Bool) in
                (myValue, triggerValue)
            }
            .filter { (myValue, triggerValue) -> Bool in
                triggerValue == true
            }
            .map { (myValue, triggerValue) -> Element in
                myValue
            }
    }
}
