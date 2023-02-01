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
    @State private var isPlacementEnabled = false //swiftui to auto update interface as the variable changes
    @State private var selectedModel: String?
    @State private var modelConfirmedForPlacement: String?
    
    var models: [String] = ["Human_skull", "Lungs"]
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, models: self.models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: String?
    
    // Update AR placement (adding interaction)
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = self.modelConfirmedForPlacement {
            
            print("DEBUG: adding model with scene - \(modelName)")
            
            let fileName = modelName + ".usdz"
            
            let modelEntity = try! ModelEntity.loadModel(named: fileName)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            
            uiView.scene.addAnchor(anchorEntity)
            
            modelEntity.generateCollisionShapes(recursive: true)
            
            //install gestures for movement
            uiView.installGestures([.translation, .rotation, .scale], for: modelEntity)
        
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
    
    // AR objects placement
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
}



    struct ModelPickerView: View {
        @Binding var isPlacementEnabled: Bool
        @Binding var selectedModel: String? //optional string instead of string type
        
        var models: [String]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(0 ..< self.models.count) {
                        index in
                        Button(action: {
                            print("DEBUG: selected model with name: \(self.models[index])")
                            
                            self.selectedModel = self.models[index]
                            
                            self.isPlacementEnabled = true
                        }){
                            Image(uiImage: UIImage(named: self.models[index])!)
                                .resizable()
                                .frame(height: 80)
                                .aspectRatio(1/1, contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
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
