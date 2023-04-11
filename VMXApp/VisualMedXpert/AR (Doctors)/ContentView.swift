//
//  ContentView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 10/12/2022.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity
import SmartHitTest

struct ContentView: View {
    @State private var placeModel = false
    @State private var selectedModel: String?
    @State private var modelConfirmedForPlacement: String?
    
    var models: [String] = ["femaleSkeleton", "maleSkeleton", "humanHeart", "headStudy", "humanLungs", "humanBrain", "human_body", "human_kidney", "human_eye1", "human_skull", "human_stomach", "human_pelvis", "human_teeth", "female_torso"]
    var modelLabels: [String] = ["Female Skeleton", "Male Skeleton", "Human Heart", "Head Study", "Human Lungs", "Human Brain", "Human Body", "Human Kidney", "Human Eye", "Human Skull", "Human Stomach", "Human Pelvis", "Human Teeth", "Female Torso"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            
            if self.placeModel {
                PlacementButtonsView(isPlacementEnabled: self.$placeModel, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacementEnabled: self.$placeModel, selectedModel: self.$selectedModel, models: self.models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let focusSquare = FocusEntity(on: uiView, focus: .classic)
        if let cameraTransform = uiView.session.currentFrame?.camera.transform {
            let cameraPosition = SIMD3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
            focusSquare.position = cameraPosition
        }
        
        if let modelName = self.modelConfirmedForPlacement {
            print("DEBUG: adding model with scene - \(modelName)")
            let fileName = modelName + ".usdz"
            let modelEntity = try! ModelEntity.loadModel(named: fileName)
            
            // Center the modelEntity
            let bounds = modelEntity.visualBounds(relativeTo: modelEntity)
            let center = bounds.center
            modelEntity.position -= center
            
            // Remove all existing anchors before adding the new one
            uiView.scene.anchors.removeAll()

            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.addChild(modelEntity)
            uiView.scene.addAnchor(anchorEntity)
            modelEntity.generateCollisionShapes(recursive: true)

            // Set the scale of the modelEntity
            let scaleFactor: Float = 0.4
            modelEntity.scale = SIMD3<Float>(repeating: scaleFactor)

            // Add a delay before installing gestures
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                uiView.installGestures([.translation, .rotation, .scale], for: modelEntity)
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
}



    struct ModelPickerView: View {
        @Binding var isPlacementEnabled: Bool
        @Binding var selectedModel: String? //optional string instead of string type
        
        //var models: [String]
        var models: [String] = ["femaleSkeleton", "maleSkeleton", "humanHeart", "headStudy", "humanLungs", "humanBrain", "human_body", "human_kidney", "human_eye1", "human_skull", "human_stomach", "human_pelvis", "human_teeth", "female_torso"]
        var modelLabels: [String] = ["Female Skeleton", "Male Skeleton", "Human Heart", "Head Study", "Human Lungs", "Human Brain", "Human Body", "Human Kidney", "Human Eye", "Human Skull", "Human Stomach", "Human Pelvis", "Human Teeth", "Female Torso"]
        
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(0 ..< self.models.count) { index in
                        VStack {
                            Button(action: {
                                print("DEBUG: selected model with name: \(self.models[index])")
                                
                                self.selectedModel = self.models[index]
                                
                                self.isPlacementEnabled = true
                            }) {
                                Image(uiImage: UIImage(named: self.models[index])!)
                                    .resizable()
                                    .frame(height: 80)
                                    .aspectRatio(1/1, contentMode: .fit)
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(self.modelLabels[index])
                                .foregroundColor(.white)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(.top, 8)
                        }
                    }
                }
            }
            .padding(20)
            .background(Color.black.opacity(0.5))
        }
    }

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var modelConfirmedForPlacement: String?
    
    var body: some View {
        HStack {
            // Cancel Button
            Button(action: {
                print("DEBUG: Cancel model placement")
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white
                        .opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            // Confirm Button
            
            Button(action: {
                print("DEBUG: Confirm model placement")
                
                self.modelConfirmedForPlacement = self.selectedModel
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white
                        .opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}



#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

