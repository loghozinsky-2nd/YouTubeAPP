// Sasha Loghozinsky -- loghozinsky@gmail.com
import UIKit

extension UILabel {}

class Label: UILabel {
    
    convenience init(_ value: String, size: CGFloat = 17, lineHeight: CGFloat = 1.01, fontWeight: UIFont.Weight = .bold, numberOfLines: Int = 0, color: UIColor = .black, strikethroughStyle: Int = 0, kern: CGFloat = -0.41, lineBreakMode: NSLineBreakMode = .byWordWrapping, textAlignment: NSTextAlignment = .left) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        setValue(value, size: size, lineHeight: lineHeight, fontWeight: fontWeight, numberOfLines: numberOfLines, color: color, strikethroughStyle: strikethroughStyle, textAlignment: textAlignment)
    }
    
    let custom = NSAttributedString.Key.self
    
    var color: UIColor!
    var size: CGFloat!
    var weight: UIFont.Weight!
    var kern: CGFloat!
    var strikethroughStyle: Int!
    let paragraphStyle = NSMutableParagraphStyle()
    
    func setValue(_ value: String, size: CGFloat = 17, lineHeight: CGFloat = 1.01, fontWeight: UIFont.Weight = .light, numberOfLines: Int = 0, color: UIColor = .black, kern: CGFloat = -0.41, lineBreakMode: NSLineBreakMode = .byWordWrapping, strikethroughStyle: Int = 0, textAlignment: NSTextAlignment = .left) {
        self.numberOfLines = numberOfLines
        self.color = color
        self.size = size
        self.weight = fontWeight
        self.kern = kern
        self.strikethroughStyle = strikethroughStyle
        self.paragraphStyle.alignment = textAlignment
        self.paragraphStyle.lineBreakMode = lineBreakMode
        self.paragraphStyle.lineHeightMultiple = lineHeight
        
        setAttributedText(value)
    }
    
    func setAttributedText(_ string: String?, withColor color: UIColor? = nil) {
        let string: String = string != nil ? string! : ""
        let color: UIColor = color != nil ? color! : self.color
        self.attributedText = NSMutableAttributedString(string: string, attributes: [self.custom.foregroundColor: color, self.custom.kern: self.kern ?? -0.41, self.custom.font: UIFont.systemFont(ofSize: self.size, weight: self.weight), self.custom.strikethroughStyle: self.strikethroughStyle!, self.custom.paragraphStyle: self.paragraphStyle])
    }
    
}
