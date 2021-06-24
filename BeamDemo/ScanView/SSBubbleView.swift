//
//  SSBubbleView.swift
//  BeamDemo
//
//  Created by Tiana  on 23/02/2021.
//

import UIKit
import SceneKit
import Vision

class SSBubbleView: UIView {

    weak var labelNode: BubbleNode!

    //Button used to display detection bubbles
    var labelButton = UIButton()

    //setup our node in the BubbleView
    init(node: BubbleNode) {
        self.labelNode = node

        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))

        //Setup of bubble layout
        let detectionBubble = CAShapeLayer()
        let radius: CGFloat = 18.5
        detectionBubble.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath

        detectionBubble.fillColor = UIColor.white.withAlphaComponent(0.25).cgColor
        detectionBubble.borderColor = UIColor.white.cgColor
        detectionBubble.borderWidth = 4.0
        detectionBubble.cornerRadius = 20
        detectionBubble.bounds = detectionBubble.path!.boundingBox
        detectionBubble.name = "Detection Bubble"

        labelButton.layer.addSublayer(detectionBubble)
        self.addSubview(labelButton)
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}

class BubbleNode: SCNNode {

    let bubbleColor = UIColor.clear
    let bubble = SCNSphere()

    var objectObservation: VNRecognizedObjectObservation? {
        didSet {
            addBubbleNode(color: bubbleColor)
        }
    }

    private func addBubbleNode(color: UIColor) {
        DispatchQueue.main.async {
            let sphereNode = self.createSphereNode(color: color)

            self.addChildNode(sphereNode)
        }
    }

    private func createSphereNode(color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: 0.01)
        geometry.materials.first?.diffuse.contents = color
        return SCNNode(geometry: geometry)
    }

}
