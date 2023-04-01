//
//  XrayImageClassification.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 10/02/2023.
//

import SwiftUI
import CoreML

struct XrayImageClassification: View {
    
    let model = CovidClassifier_1()
    
    @State private var classificationLabel: String = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    //    let photos = ["covid", "normal", "images"]
    //    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .frame(width: 200, height: 200)
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    
                    Text("Gallery")
                        .font(.headline)
                }
            }
            // button to classify the image using the model
            Button("Classify") {
                // Add more code here
                classifyImage()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            
            // textview to display the results of the classification
            Text(classificationLabel)
                .padding()
                .font(.body)
            Spacer()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
    
    
    private func classifyImage() {
        let currentImageName = image
        let image = currentImageName
        
        let resizedImage = image.resizeImageTo(size:CGSize(width: 299, height: 299))
        guard let buffer = resizedImage?.convertToBuffer()
        else {
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
            if let output = output {
                let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
                let result = results.map { (key, value) in
                    return "\(key) = \(String(format: "%.2f", value * 100))%"
                }.joined(separator: "\n")
                
                self.classificationLabel = result
        }
    }
}


struct XrayImageClassification_Previews: PreviewProvider {
    static var previews: some View {
        XrayImageClassification()
    }
}
