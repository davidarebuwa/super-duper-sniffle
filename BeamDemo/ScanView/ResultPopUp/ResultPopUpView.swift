import UIKit
import SwiftMessages

class ResultPopUp: MessageView {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    
    public func updateResultText(){
        let attributed = NSMutableAttributedString(string: "Stability Ball\n", attributes: [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ])
        attributed.append(NSAttributedString(string: "Core, Bodybuilding\n+5 more", attributes: [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 15, weight: .medium)
        ]))
        titleView.attributedText = attributed
    }
}
