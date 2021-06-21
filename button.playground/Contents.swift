import UIKit
import PlaygroundSupport

let fonts = ["Inter-Medium.otf", "Inter-Regular.otf"]
let fontUrls = fonts
    .map { fontResource in
        Bundle.main.url(forResource: fontResource, withExtension: nil)!
    }
    .map { $0 as CFURL }
CTFontManagerRegisterFontURLs(fontUrls as CFArray, .process, true, nil)

enum FontWeight {
    case regular
    case medium
}
extension UIFont {
    static func brandedFont(_ size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        switch weight {
        case .regular: return UIFont(name: "Inter-Regular", size: size)!
        case .medium: return UIFont(name: "Inter-Medium", size: size)!
        }
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 600))
view.backgroundColor = UIColor(red: 0.82, green: 0.89, blue: 0.92, alpha: 1)

let stack = UIStackView()
stack.spacing = 30
stack.axis = .vertical
stack.alignment = .center
stack.distribution = .fill

view.addSubview(stack)
stack.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])

extension StyledButton {
    struct Config {
        let backgroundColor: UIColor
        let highlightedBackgroundColor: UIColor
        let foregroundColor: UIColor
        var icon: UIImage?
        var selectedIcon: UIImage?
        
        static func light() -> Config {
            Config(
                backgroundColor: .white,
                highlightedBackgroundColor: UIColor(hex: "#FAFBFF")!,
                foregroundColor: UIColor(hex: "#404660")!
            )
        }
        
        static func dark() -> Config {
            Config(
                backgroundColor: UIColor(hex: "#1E2235")!,
                highlightedBackgroundColor: UIColor(hex: "#171827")!,
                foregroundColor: UIColor(hex: "#F9FAFF")!
            )
        }
    }
    
    struct Shadow {
        let offset: CGSize
        let radius: CGFloat
        let color: UIColor
        let opacity: Float
        
        static func standard() -> Shadow {
            Shadow(offset: .init(width: 0, height: 2), radius: 3, color: UIColor(hex: "#001384")!, opacity: 0.2)
        }
        
        static func pressed() -> Shadow {
            Shadow(offset: .init(width: 0, height: 1), radius: 1, color: UIColor(hex: "#001384")!, opacity: 0.2)
        }
    }
}

class StyledButton: UIButton {
    
    private var config: Config {
        didSet {
            updateDisplay()
        }
    }
    
    init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        config = .light()
        super.init(coder: coder)
        configure()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 140, height: 40)
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
                self.backgroundColor = self.isHighlighted ? self.config.highlightedBackgroundColor : self.config.backgroundColor
                self.applyShadow(shadow: self.isHighlighted ?
                                .pressed() : .standard()
                )
                
                self.transform = self.isHighlighted ?
                    .init(translationX: 0, y: 1)
                    : .identity
            }
        }
    }
    
    private func configure() {
        layer.cornerRadius = 6
        titleLabel?.font = .brandedFont(14, weight: .medium)
        applyShadow(shadow: .standard())
        updateDisplay()
    }
    
    private func applyShadow(shadow: Shadow) {
        layer.shadowOffset = shadow.offset
        layer.shadowColor = shadow.color.cgColor
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = shadow.opacity
    }
    
    private func updateDisplay() {
        backgroundColor = config.backgroundColor
        setTitleColor(config.foregroundColor, for: .normal)
        setImage(config.icon, for: .normal)
        
        if let selectedIcon = config.selectedIcon {
            setImage(selectedIcon, for: .selected)
        }
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageSize = image(for: state)?.size ?? .zero
        let marginX: CGFloat = 20
        let imageY = (contentRect.height - imageSize.height) / 2
        return CGRect(x: marginX, y: imageY, width: imageSize.width, height: imageSize.height)
    }
}

var config1 = StyledButton.Config.light()
config1.icon = UIImage(systemName: "bookmark")?
    .withTintColor(UIColor(hex: "#8A91B4")!)
    .withRenderingMode(.alwaysOriginal)
let button1 = StyledButton(config: config1)
button1.setTitle("Bookmark", for: .normal)

var config2 = config1
config2.selectedIcon = UIImage(systemName: "bookmark.fill")?
    .withTintColor(UIColor(hex: "#F04949")!)
    .withRenderingMode(.alwaysOriginal)
let button2 = StyledButton(config: config2)
button2.isSelected = true
button2.setTitle("Bookmark", for: .normal)

var config3 = StyledButton.Config.dark()
config3.icon = UIImage(systemName: "bookmark")?
    .withTintColor(UIColor(hex: "#8A91B4")!)
    .withRenderingMode(.alwaysOriginal)
let button3 = StyledButton(config: config3)
button3.setTitle("Bookmark", for: .normal)

var config4 = StyledButton.Config.dark()
config4.icon = UIImage(systemName: "bookmark")?
    .withTintColor(UIColor(hex: "#8A91B4")!)
    .withRenderingMode(.alwaysOriginal)

config4.selectedIcon = UIImage(systemName: "bookmark.fill")?
    .withTintColor(UIColor(hex: "#F04949")!)
    .withRenderingMode(.alwaysOriginal)
let button4 = StyledButton(config: config4)
button4.isSelected = true
button4.setTitle("Bookmark", for: .normal)

stack.addArrangedSubview(Helper.labeledView(button1, label: "Light | normal"))
stack.addArrangedSubview(Helper.labeledView(button2, label: "Light | selected"))
stack.addArrangedSubview(Helper.labeledView(button3, label: "Dark | normal"))
stack.addArrangedSubview(Helper.labeledView(button4, label: "Dark | selected"))

PlaygroundPage.current.liveView = view

