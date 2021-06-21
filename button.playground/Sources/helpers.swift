import UIKit

public struct Helper {
    public static func labeledView(_ view: UIView, label text: String) -> UIView {
        let stack = UIStackView()
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .center
        stack.addArrangedSubview(view)
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        let modifier: CGFloat = 0.8
        label.textColor = UIColor(red: 0.82 * modifier, green: 0.89 * modifier, blue: 0.92 * modifier, alpha: 1)
        label.text = text
        stack.addArrangedSubview(label)
        
        return stack
    }
}
