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
    
    @State private var displayResult: String = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    @State private var covidProgress: Double = 0.0
    @State private var normalProgress: Double = 0.0
    
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
            
            Button("Classify") {
                classifyImage()
            }
            .padding()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
            
            // progress bars for Covid and Normal classifications
            VStack {
                HStack {
                    Text("Covid")
                    ProgressView(value: covidProgress, total: 1.0, label: {
                        Text(String(format: "%.2f", covidProgress * 100) + "%")
                    })
                    .accentColor(.red)
                }
                .padding()
                HStack {
                    Text("Normal")
                    ProgressView(value: normalProgress, total: 1.0, label: {
                        Text(String(format: "%.2f", normalProgress * 100) + "%")
                    })
                    .accentColor(.green)
                }
                .padding()
            }
            Spacer()
//            Text(displayResult)
//                .padding()
//                .font(.body)
//
//            Spacer()
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
            
            //self.displayResult = result
            
            if let covid = output.classLabelProbs["Covid"] {
                self.covidProgress = covid
            }
            if let normal = output.classLabelProbs["Normal"] {
                self.normalProgress = normal
            }
        }
    }
}

struct XrayImageClassification_Previews: PreviewProvider {
    static var previews: some View {
        XrayImageClassification()
    }
}






