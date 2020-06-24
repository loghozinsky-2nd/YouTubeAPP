// Sasha Loghozinsky -- loghozinsky@gmail.com
import UIKit

extension UIColor {
    open class var basicColor: UIColor {
        get {
            return UIColor(red: 36/255, green: 41/255, blue: 46/255, alpha: 1)
        }
    }
    
    open class var accentColor: UIColor {
        get {
            return UIColor(displayP3Red: 238/255, green: 66/255, blue: 137/255, alpha: 1)
        }
    }
    

    open class var accentDarkenColor: UIColor {
        get {
            return UIColor(displayP3Red: 99/255, green: 11/255, blue: 245/255, alpha: 1)
        }
    }
}

extension CGColor {
    open class var basicColor: CGColor {
        get {
            return UIColor.basicColor.cgColor
        }
    }
    open class var accentColor: CGColor {
        get {
            return UIColor.accentColor.cgColor
        }
    }
    open class var accentDarkenColor: CGColor {
        get {
            return UIColor.accentDarkenColor.cgColor
        }
    }
}
