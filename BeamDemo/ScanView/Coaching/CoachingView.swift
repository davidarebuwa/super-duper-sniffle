
import UIKit
import SwiftMessages

class CoachingView: MessageView {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var topInset: NSLayoutConstraint!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let statusbar = UIApplication.shared.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        topInset.constant = statusbar + 10 // 10 = top constraint of the buttons ( flash and card )
    }
    
    public func updateCoachingText(text: String){
        titleView.text = text
    }
}
