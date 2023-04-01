//
//  DirectImageClassification.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 11/02/2023.
//

import SwiftUI

struct DirectImageClassification: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: XrayImageClassification()) {
                    Text("Image Classification")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        
        .navigationBarTitle("Image Classifier")
        
    }
}

struct DirectImageClassification_Previews: PreviewProvider {
    static var previews: some View {
        DirectImageClassification()
    }
}
