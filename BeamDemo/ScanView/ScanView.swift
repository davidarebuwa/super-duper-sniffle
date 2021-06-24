//
//  ViewController.swift
//  BeamDemo
//
//  Created by Tiana  on 18/02/2021.
//

import UIKit
import SceneKit
import ARKit
import SwiftMessages
import CoreML
import Vision


class ScanView: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var overlayWidth: NSLayoutConstraint!
    let configuration = ARWorldTrackingConfiguration()
    let coachingSession = SwiftMessages()
    let resultSession = SwiftMessages()
    let errorSession = SwiftMessages()
    let onboardingSession = SwiftMessages()
    
    //ML
    let objRecModel: Objects = {
        do {
        let config = MLModelConfiguration()
        return try Objects(configuration: config)
        } catch {
        print(error)
        fatalError("Couldn't create Obj Rec model")
        }
    }()
    //Object store for  model
    var model: VNCoreMLModel!
    //Concurrent queue to be used for model predictions
    let predictionQueue = DispatchQueue(label: "predictionQueue")
    //Flag for conducting ML predicitons
    var isPerformingCoreML = false
    //Object used for tracking last made prediction
    var latestResult: VNRecognizedObjectObservation?
    //Flag for detecting if object has been detected
    var isDetected = false
    
    //AR
    var bubbleName: String = ""
    var screenCenter: CGPoint?
    var bubbles: [BubbleNode] = []
    var ssViews: [SSBubbleView] = []
    var isDisplayingResult = false
    //flag for observing if object has been tapped
    var isObjectTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics  = false
        let scene = SCNScene()
        sceneView.scene = scene
        model = try? VNCoreMLModel(for: objRecModel.model)
        showOnboardingCard()
        //showResultPopUp()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
        view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.overlayWidth.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        screenCenter = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseCoreML()
        sceneView.session.pause()
    }
    
    
    
    @IBAction func toggleFlash(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
            sender.tintColor = .systemYellow
            toggleTorch(true)
        } else {
            sender.tag = 0
            sender.setImage(UIImage(systemName: "bolt"), for: .normal)
            sender.tintColor = .white
            toggleTorch(false)
        }
    }
    
    private func toggleTorch(_ mode: Bool) {
        if let device = AVCaptureDevice.default(for: AVMediaType.video),
           let _ = try? device.lockForConfiguration(),
           device.hasTorch {
            device.torchMode = mode ? .on : .off
            device.unlockForConfiguration()
        }
    }
    
    
    private func showOnboardingCard() {
        self.view.layer.pause()
        if let popup = try? SwiftMessages.viewFromNib(named: "CardView") as? CardView {
            var config = SwiftMessages.defaultConfig
            config.interactiveHide = true
            config.duration = .forever
            config.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
            config.presentationStyle = .bottom
            popup.buttonAction = {
                popup.player?.pause()
                self.onboardingSession.hide()
                print("button pressed")
                self.view.layer.resume()
                    self.showCoachingToast(title: "Please keep device steady")
            }
            popup.configurePlayer(url: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4")
            
            onboardingSession.show(config: config, view: popup)
        }
        
    }
    
     func showCoachingToast(title: String){
        if let toast = try? SwiftMessages.viewFromNib(named: "CoachingView") as? CoachingView {
            var config = SwiftMessages.defaultConfig
            config.interactiveHide = false
            config.duration = .seconds(seconds: 3.0)
            config.dimMode = .none
            config.presentationStyle = .top
            
            toast.updateCoachingText(text: title)
            coachingSession.show(config: config, view: toast)
        }
    }
    
    
    
    private func showErrorCard() {
        self.view.layer.pause()
        if let popup = try? SwiftMessages.viewFromNib(named: "ErrorView") as? ErrorView {
            var config = SwiftMessages.defaultConfig
            config.interactiveHide = true
            config.duration = .forever
            config.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
            config.presentationStyle = .bottom
            
            popup.buttonAction = {
                self.errorSession.hide()
                print("error button pressed")
                self.view.layer.resume()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showCoachingToast(title: "Please keep device steady")
                }
            }
            
            errorSession.show(config: config, view: popup)
        }
        
    }

    
}



