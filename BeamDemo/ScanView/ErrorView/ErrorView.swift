
import UIKit
import SwiftMessages

class ErrorView: MessageView {
    var buttonAction: (() -> Void)?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onButtonPress() {
        buttonAction?()
    }
}
