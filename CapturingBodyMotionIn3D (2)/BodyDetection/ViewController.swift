/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    var bodySkeleton: BodySkeleton?
    var bodySkeletonAnchor = AnchorEntity()
    var anchorPosition = simd_float3()
    
    var modelAnchor = AnchorEntity()
    let mesh = MeshResource.generateSphere(radius: 0.015)
    let material = SimpleMaterial(color: .green, isMetallic: false)
    var modelEntity = ModelEntity()

//    var modelAnchor = AnchorEntity()
//    var modelEntity = ModelEntity()
    
    // The 3D character to display.
//    var character: BodyTrackedEntity?
//    let characterOffset: SIMD3<Float> = [-0, 0, 0] // Offset the character by one meter to the left
//    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelEntity=ModelEntity(mesh: mesh, materials: [material])
        
       
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        arView.scene.addAnchor(bodySkeletonAnchor)
        arView.scene.addAnchor(modelAnchor)
        
         modelAnchor.addChild(modelEntity)
//        arView.scene.addAnchor(bodySkeletonAnchor)
        
        // Asynchronously load the 3D character.
//        var cancellable: AnyCancellable? = nil
//        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
//            receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    print("Error: Unable to load model: \(error.localizedDescription)")
//                }
//                cancellable?.cancel()
//        }, receiveValue: { (character: Entity) in
//            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
//                character.scale = [1.0, 1.0, 1.0]
//                self.character = character
//                cancellable?.cancel()
//            } else {
//                print("Error: Unable to load model as BodyTrackedEntity")
//            }
//        })
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        
        
    }
    
        
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//        for anchor in anchors {
//            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
//        
//            // Update the position of the character anchor's position.
//            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
//            characterAnchor.position = bodyPosition + characterOffset
//            // Also copy over the rotation of the body anchor, because the skeleton's pose
//            // in the world is relative to the body anchor's rotation.
//            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
//   
//            if let character = character, character.parent == nil {
//                // Attach the character to its anchor as soon as
//                // 1. the body anchor was detected and
//                // 2. the character was loaded.
//                characterAnchor.addChild(character)
            
        
        
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                
                
                
                let skeleton = bodyAnchor.skeleton
                
                let rightsholderTransform = simd_make_float3(bodyAnchor.skeleton.modelTransform(for:ARSkeleton.JointName(rawValue: "right_arm_joint"))!.columns.3)
                let leftsholderTransform = simd_make_float3(bodyAnchor.skeleton.modelTransform(for:ARSkeleton.JointName(rawValue: "left_arm_joint"))!.columns.3)
                let leftHipTransform = simd_make_float3(bodyAnchor.skeleton.modelTransform(for:ARSkeleton.JointName(rawValue: "left_upLeg_joint"))!.columns.3)
                let rightHipTransform = simd_make_float3(bodyAnchor.skeleton.modelTransform(for:ARSkeleton.JointName(rawValue: "right_upLeg_joint"))!.columns.3)
                
                

//                let rootJointTransfrom = skeleton.modelTransform(for: .root)!
                let rootAnchor=simd_make_float3(bodyAnchor.transform.columns.3)
                let rootJointPosition = rootAnchor//simd_make_float3(rootJointTransfrom.columns.3)
                
                
//
                let rightShloderOffset = simd_make_float3(rightsholderTransform)
                let rightShloderPosition = rootAnchor + rightShloderOffset
//
//                
//
                let leftShloderOffset = simd_make_float3(leftsholderTransform)
                let leftShloderPosition = rootAnchor + leftShloderOffset
//
//                
//
                let rightHipOffset = simd_make_float3(rightHipTransform)
                let rightHipPosition = rootAnchor + rightHipOffset
                
                
                let leftHipOffset = simd_make_float3(leftHipTransform)
                let leftHipPosition = rootAnchor + leftHipOffset
                
                
                let point1 = simd_float3(rightShloderPosition.x, rightShloderPosition.y, rightShloderPosition.z)
                
                let point2 = simd_float3(leftShloderPosition.x, leftShloderPosition.y, leftShloderPosition.z)
                
                let point3 = simd_float3(rightHipPosition.x, rightHipPosition.y, rightHipPosition.z)
//
                let point4 = simd_float3(leftHipPosition.x, leftHipPosition.y, leftHipPosition.z)
                
                let A = simd_float3((point1.x+point2.x)/2,point1.y, point1.z)
                let B = simd_float3(A.x-0.3*abs(point2.x-A.x),point1.y, A.z)
                let F = simd_float3((point3.x+point4.x)/2,point3.y, B.z)
                let E = simd_float3(A.x,A.y+0.3*abs(A.y-F.y),F.z)
                
                var V1 =  simd_float3(A.x+0.5*abs(B.x-A.x),E.y, leftShloderPosition.z)
                let V4 = simd_float3(rightShloderPosition.x + (0.79*abs(leftShloderPosition.x-rightShloderPosition.x)),leftShloderPosition.y-abs(leftShloderPosition.y-leftHipPosition.y)*0.24,leftShloderPosition.z)
                
                anchorPosition = V1
                print("V1", anchorPosition,V4)
                print("leftShloderPosition",leftShloderPosition,simd_make_float3(leftsholderTransform)+rootAnchor,rootAnchor,simd_make_float3(leftsholderTransform))
                
             
               
                
                

               
//                modelAnchor = AnchorEntity(anchor: bodyAnchor)
                
                modelEntity.position =  V4//rootAnchor+simd_make_float3(leftsholderTransform)
                
//                modelEntity.orientation = Transform(matrix: rootJointTransfrom).rotation
                
               
                
//                arView.scene.addAnchor(modelAnchor)
                
                
                
                if let skeleton =  bodySkeleton {
                    skeleton.update(with: bodyAnchor)
                    
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    bodySkeletonAnchor.addChild(skeleton)
                   
                }
            }
                
                
            }
            
            
            
            
            }
    }
