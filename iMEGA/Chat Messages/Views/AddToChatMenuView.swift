
import UIKit

class AddToChatMenuView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var label: UILabel!
    
    var disabled: Bool = false
    
    var menu: AddToChatMenu? {
        didSet {
            guard let menu = menu else {
                imageView.image = nil
                label.text = nil
                imageBackgroundView.isHidden = true
                return
            }
            
            imageView.image = UIImage(named: menu.imageKey)
            label.text = NSLocalizedString(menu.nameKey, comment: "")
            imageBackgroundView.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateAppearance()
    }
    
    func disable(_ disable: Bool) {
        disabled = disable
        imageView.alpha = disable ? 0.5 : 1.0
        label.alpha = disable ? 0.5 : 1.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.bounds.width / 2.0
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        imageBackgroundView.backgroundColor = .mnz_inputbarButtonBackground(traitCollection)
        label.textColor = .mnz_secondaryGray(for: traitCollection)
    }

}
