// Sasha Loghozinsky -- loghozinsky@gmail.com
import UIKit

extension UIImageView {
    convenience init(contentMode: UIView.ContentMode = .scaleAspectFill, cornerRadius: CGFloat) {
        self.init()
        
        self.clipsToBounds = true
        self.contentMode = contentMode
        self.layer.cornerRadius = cornerRadius
    }
}
