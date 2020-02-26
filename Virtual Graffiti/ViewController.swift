//
//  ViewController.swift
//  Virtual Graffiti
//
//  Created by Adriaan Engelbrecht on 2/25/20.
//  Copyright © 2020 hunter. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var stickersButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        //stickersButton.layer.borderWidth = 1
        //stickersButton.layer.cornerRadius = 10
        //stickersButton.layer.borderColor = UIColor.white.cgColor
        //placeButton.layer.borderWidth = 1
        //placeButton.layer.cornerRadius = 15
        //placeButton.layer.cornerRadius = 0.5 * placeButton.frame.width/2
        //placeButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // Function called when Settings button is pressed
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "MainToSettings", sender: self)
    }
    // Function called when Stickers button is pressed
    @IBAction func StickersButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "MainToStickers", sender: self)
    }
    
    // check before segue for passing variables to new views, checking for existing classes, etc.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
