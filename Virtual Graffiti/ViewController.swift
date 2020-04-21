//
//  ViewController.swift
//  Virtual Graffiti
//
//  Created by Hunter Salada on 2/25/20.
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
    
    var grids = [Grid]()
    public let stickerSelect: Array<String> = ["salada-character", "mona-lisa", "nick", "fran", "emily", "christine", "austin", "hunter-b" , "kellen", "hunter-s", "colonel", "fran-alt"]
    public var selectorValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // allowing a tap to place things
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
        
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
        
        // Hide navigation controller
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        // Stop hiding navigation controller
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    // MARK: - ACTIONS FROM MAIN VIEW
    
    // Function called when Settings button is pressed
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "MainToSettings", sender: self)
    }
    
    // Function called when Stickers button is pressed
    @IBAction func StickersButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "stickerTableSeg", sender: self)
    }
    
    // Function called when the place button is pressed
    @IBAction func PlaceButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "MainToWall", sender: self)
        selectorValue = (selectorValue + 1) % stickerSelect.count
    }
    
    // check before segue for passing variables to new views, checking for existing classes, etc.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let vc = segue.destination as! TableViewSticker
        //vc.stickers = self.stickerSelect
    }
    
    
    // THE FOLLOWING FUNCTIONS ARE FOR PLANE DETECTION AND PLACING 2D IMAGES
    // from the tutorial at https://mobile-ar.reality.news/how-to/arkit-101-place-2d-images-like-painting-photo-wall-augmented-reality-0187598/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = Grid(anchor: planeAnchor)
        self.grids.append(grid)
        node.addChildNode(grid)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == planeAnchor.identifier
            }.first

        guard let foundGrid = grid else {
            return
        }

        foundGrid.update(anchor: planeAnchor)
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        // Get 2D position of touch event on screen
        let touchPosition = gesture.location(in: sceneView)

        // Translate those 2D points to 3D points using hitTest (existing plane)
        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)

        // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
        guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.lastIndex(where: { $0.anchor == anchor }) else {
            return
        }
        addSticker(hitTest, grids[gridIndex])
    }
    
    func addSticker(_ hitResult: ARHitTestResult, _ grid: Grid) {
        // 1.
        let planeGeometry = SCNPlane(width: 0.2, height: 0.35)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: stickerSelect[selectorValue])
        planeGeometry.materials = [material]

        // 2.
        let stickerNode = SCNNode(geometry: planeGeometry)
        stickerNode.transform = SCNMatrix4(hitResult.anchor!.transform)
        stickerNode.eulerAngles = SCNVector3(stickerNode.eulerAngles.x + (-Float.pi / 2), stickerNode.eulerAngles.y, stickerNode.eulerAngles.z)
        stickerNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)

        sceneView.scene.rootNode.addChildNode(stickerNode)
        grid.removeFromParentNode()
    }
 
}
