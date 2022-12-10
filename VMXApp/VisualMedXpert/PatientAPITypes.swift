//
//  PatientAPITypes.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import Foundation

struct PatientElement: Codable, Hashable, Identifiable {
    let id: Int
    let fullname, dob, address, medcondition: String
    let patientdescription, symptoms, medication, notes: String
}

typealias Patient = [PatientElement]

