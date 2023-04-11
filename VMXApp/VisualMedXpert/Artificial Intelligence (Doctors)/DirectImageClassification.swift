//
//  DirectImageClassification.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 11/02/2023.
//

import SwiftUI

struct DirectImageClassification: View {
   // @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: XrayImageClassification()) {
                    Text("Covid, Viral Pneumonia or Normal")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                Spacer().frame(height: 50)
                NavigationLink(destination: COVID19_Positive_Negative()) {
                    Text("Are you Covid Postive?")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        
        .navigationBarTitle("Image Classification")
        .navigationBarBackButtonHidden(false)
    }
}

struct DirectImageClassification_Previews: PreviewProvider {
    static var previews: some View {
        DirectImageClassification()
    }
}
