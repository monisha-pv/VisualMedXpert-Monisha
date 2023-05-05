//
//  DoctorDetailViewTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 05/05/2023.
//


import XCTest
import SwiftUI

@testable import VisualMedXpert

class DoctorDetailViewTests: XCTestCase {
    
    func testDeletePatients() {
        // Arrange
        let patient = VisualMedXpertTests.Patient(id: 1, fullname: "John Doe", dob: "01/01/1970", gender: "Male", nhsNo: "12345", address: "123 Main St", medcondition: "Condition", patientdescription: "Description", symptoms: "Symptoms", medication: "Medication", notes: "Notes")
        
        let doctorDetailView = DoctorDetailView(patient: patient)
        
        // Act
        doctorDetailView.deletePatients()
    }
}

