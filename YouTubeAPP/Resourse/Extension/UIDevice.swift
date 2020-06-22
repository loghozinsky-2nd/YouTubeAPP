// Sasha Loghozinsky -- loghozinsky@gmail.com
import UIKit

extension UIDevice {
    open class var resolution: CGSize {
        get {
            return UIScreen.main.bounds.size
        }
    }
}
