import UIKit
import SwiftMessages

class BottomSheet: MessageView, UICollectionViewDataSource {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var grabberBar: UIView!
    private let rows = Int.random(in: 5...10)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.text = "Exercise"
        bottomConstraint.constant = UIDevice.current.userInterfaceIdiom == .pad ? 15 : 0
        topConstraint.constant = UIDevice.current.userInterfaceIdiom == .pad ? 0 : 15
        
        configureDropShadow()
        let cell = UINib(nibName: "BottomSheetCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "bottomCell")
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "bottomCell", for: indexPath)
    }
    
    private static let config: SwiftMessages.Config = {
        // for fun and giggles XD remove custom animator in final product!
    
        var config = SwiftMessages.defaultConfig
        config.dimMode = .none
        config.duration = .forever
        config.interactiveHide = true
        config.ignoreDuplicates = true
        config.presentationContext = .window(windowLevel: .alert)
        //config.presentationStyle = .custom(animator: animator) // .bottom
        config.presentationStyle =  .bottom

        return config
    }()
    
    class func presentSheet() {
        guard let view = try? SwiftMessages.viewFromNib(named: "BottomSheet") as? BottomSheet else {
            return
        }

        // fill view with data here -> pass parameters to presentSheet if needed
        SwiftMessages.show(config: config, view: view)
    }
    
    func dismissSheet(){
        SwiftMessages.hide()
    }
    
}
