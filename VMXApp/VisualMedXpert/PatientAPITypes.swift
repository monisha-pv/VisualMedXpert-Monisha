//
//  PatientAPITypes.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import Foundation

struct Patient: Codable, Hashable, Identifiable {
    
    var id: Int
    var fullname: String
    var dob: String
    var address: String
    var medcondition: String
    var patientdescription: String
    var symptoms: String
    var medication: String
    var notes: String
}


