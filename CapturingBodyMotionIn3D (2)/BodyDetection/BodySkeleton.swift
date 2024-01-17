//
//  BodySkeleton.swift
//  BodyDetection
//
//  Created by Sanket Lothe on 16/01/24.
//  Copyright © 2024 Apple. All rights reserved.
//
import RealityKit
import ARKit

class BodySkeleton: Entity {
    
    var joints: [String: Entity] = [:]
    let requiredJoints:[String] = ["left_shoulder_1_joint","right_shoulder_1_joint","left_upLeg_joint","right_upLeg_joint","right_forearm_joint","left_forearm_joint","right_arm_joint","left_arm_joint"]
    
    required init(for bodyAnchor: ARBodyAnchor) {
        
        super.init()
        
        var jointsNameArray = ARSkeletonDefinition.defaultBody3D.jointNames
        let newJointsArray = ["A","B","C","D"]
        jointsNameArray.append(contentsOf: newJointsArray)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            print("jointName",jointName)
            var jointRadius: Float = 0.01
            var jointColor: UIColor = .red
            
            if requiredJoints.contains(jointName) {
                
                let jointEntity = makeJoint(radius: jointRadius, color: jointColor)
                joints[jointName] = jointEntity
                self.addChild(jointEntity)
                print("jointname", jointName)
            }
            
            self.update(with: bodyAnchor)
        }
        
    }
    
    func makeJoint(radius: Float, color: UIColor) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        return modelEntity
    }
    
    
    func update(with bodyAnchor: ARBodyAnchor) {
        let rootPosition =  simd_make_float3(bodyAnchor.transform.columns.3)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            print("jointName",jointName)
            if let jointEntity = joints[jointName], let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                print("jointTransform",jointTransform)
                let jointOffset = simd_make_float3(jointTransform.columns.3)
                jointEntity.position =  rootPosition + jointOffset
                jointEntity.orientation = Transform(matrix: jointTransform).rotation
            }
        }
    }
    
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
