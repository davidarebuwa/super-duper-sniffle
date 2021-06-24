import UIKit
import ARKit
import SwiftMessages

extension ScanView {

    func hitTest() {

        guard let frame = sceneView.session.currentFrame else { return }

        let state = frame.camera.trackingState
        switch state {
        case .normal:
            guard let pos = screenCenter else { return }
            DispatchQueue.main.async(execute: {
                self.hitTest(pos)
            })

        default:
            break

        }
    }

    func hitTest(_ pos: CGPoint) {
        let nodeResults = sceneView.hitTest(pos, options: [.boundingBoxOnly: true])
        for nodeResult in nodeResults {
            if let overlappingTag = nodeResult.node.parent as? BubbleNode {
                removeBubble(bubble: overlappingTag)
            }
        }

        let results1 = sceneView.hitTest(pos, types: [.existingPlaneUsingExtent, .estimatedHorizontalPlane])
        if let result = results1.first {
            addBubble(for: result)
            return
        }

        let results2 = sceneView.hitTest(pos, types: [.featurePoint])
        if let result = results2.first {
            addBubble(for: result)
            return
        }
    }

    // MARK: - Detection Bubble Function Calls

    func addBubble(for hitTestResult: ARHitTestResult) {
        let bubbleNode = BubbleNode()
        // bubbleNode.transform = SCNMatrix4(hitTestResult.worldTransform)

        bubbleNode.worldPosition = SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)

        bubbleNode.objectObservation = latestResult
        sceneView.scene.rootNode.addChildNode(bubbleNode)

        let bubbleView = SSBubbleView(node: bubbleNode)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        bubbleView.addGestureRecognizer(tap)

        self.view.addSubview(bubbleView)
        self.ssViews.append(bubbleView)
        self.bubbles.append(bubbleNode)
        
        //Show toast
        showCoachingToast(title: "Equipment found!")

    }

    func removeBubble(bubble: BubbleNode) {
        bubble.removeFromParentNode()
        guard let index = bubbles.firstIndex(of: bubble) else { return }
        bubbles.remove(at: index)
    }

    //reset all bubbles in the scene
    func resetBubbles() {
        for child in sceneView.scene.rootNode.childNodes {
            if child is BubbleNode {
                guard let bubble = child as? BubbleNode else {
                    fatalError()
                }
                removeBubble(bubble: bubble)
            }
        }

    }

    //Bubble Tap Function Call
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
     

        isObjectTapped = true

        bubbleName = latestResult?.labels.first?.identifier.capitalizingFirstLetter() ?? "nil"

        print("Tapped on \(bubbleName)")

        print("tap location: \(gesture.location(in: gesture.view))")

        isDisplayingResult = true
       //navigate(.resultView(prediction: bubbleName))
        showResultPopUp()
    }
    
    func showResultPopUp(){
       if let  popup = try? SwiftMessages.viewFromNib(named: "ResultPopUp") as? ResultPopUp {
           var config = SwiftMessages.defaultConfig
           config.interactiveHide = true
           config.duration = .forever
           config.dimMode = .blur(style: .light, alpha: 0.2, interactive: true)
           config.presentationStyle = .bottom
           popup.updateResultText()
        popup.tapHandler = { _ in
            print("Tapped!")
            //SwiftMessages.hide(popup)
            SwiftMessages.hideAll()
            self.performSegue(withIdentifier: "goToEquipment", sender: self)
        }
        
        pauseCoreML()
           resultSession.show(config: config, view: popup)
       }
   }
    

}
