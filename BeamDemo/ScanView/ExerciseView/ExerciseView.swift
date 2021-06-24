import UIKit
import SceneKit
import SwiftMessages

class ExerciseView: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    var listSession = SwiftMessages()
    
    override func viewDidLoad() {
        
        navigationItem.title = "Exercise"
        
        // 1: Load .obj file
        let scene = SCNScene(named: "toy_drummer.usdz")
        
        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
        // 4: Set camera on scene
        scene?.rootNode.addChildNode(cameraNode)
        
        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(lightNode)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        
        sceneView.allowsCameraControl = true
        
        // Show FPS logs and timming
        // sceneView.showsStatistics = true
        
        // Set background color
        sceneView.backgroundColor = UIColor.systemBackground
        
        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false
        
        // Set scene settings
        sceneView.scene = scene
             
       // BottomSheet.presentSheet()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BottomSheet.presentSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftMessages.hideAll()
    }

    @IBAction func showARView(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToARExerciseView", sender: self)
    }
    

}
