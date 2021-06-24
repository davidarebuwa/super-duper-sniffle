import UIKit
import ARKit

extension ScanView: ARSCNViewDelegate, ARSessionDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        performCoreML()

    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {

        for bubble in bubbles {

            let projectedPosition = self.sceneView.projectPoint(bubble.position)

            for view in ssViews {
                onlyShowViewsInFront(projectedPosition: projectedPosition, view: view)

                let size = view.frame.size
                let x = CGFloat(projectedPosition.x) - size.width / 2
                let y = CGFloat(projectedPosition.y) - size.height / 2

                view.frame.origin = CGPoint(x: x, y: y)

            }
        }

    }

    fileprivate func onlyShowViewsInFront(projectedPosition: SCNVector3, view: UIView) {
        if projectedPosition.z > 1 {
            view.isHidden = true
        } else {
            view.isHidden = false
        }

    }

}
