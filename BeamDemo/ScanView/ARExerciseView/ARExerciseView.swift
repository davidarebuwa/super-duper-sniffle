//
//  ARExerciseView.swift
//  BeamDemo
//
//  Created by Tiana  on 22/06/2021.
//

import UIKit
import SceneKit
import ARKit
import SwiftMessages

class ARExerciseView: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet weak var arSceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        arSceneView.delegate = self
        arSceneView.session.delegate = self
        arSceneView.showsStatistics  = false
        let scene = SCNScene()
        arSceneView.scene = scene
        BottomSheet.presentSheet()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arSceneView.session.run(configuration)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
