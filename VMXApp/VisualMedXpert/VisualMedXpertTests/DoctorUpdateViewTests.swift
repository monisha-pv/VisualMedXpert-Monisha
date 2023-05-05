//
//  DoctorUpdateViewTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 05/05/2023.
//

import XCTest
import SwiftUI

@testable import VisualMedXpert

class DoctorUpdateViewTests: XCTestCase {
    
    func testPutPatients() {
        // Arrange
        var patient = Patient(id: 1, fullname: "John Doe", dob: "01/01/1970", gender: "Male", nhsNo: "12345", address: "123 Main St", medcondition: "Condition", patientdescription: "Description", symptoms: "Symptoms", medication: "Medication", notes: "Notes")
        
        let binding = Binding<Patient>(get: { patient }, set: { patient = $0 })
        let doctorUpdateView = DoctorUpdateView(patient: binding)
        
        // Act
        doctorUpdateView.putPatients()
        
        XCTAssertEqual(patient.fullname, "John Doe")
        XCTAssertEqual(patient.dob, "01/01/1970")
        XCTAssertEqual(patient.gender, "Male")
        XCTAssertEqual(patient.nhsNo, "12345")
        XCTAssertEqual(patient.address, "123 Main St")
        XCTAssertEqual(patient.medcondition, "Condition")
        XCTAssertEqual(patient.patientdescription, "Description")
        XCTAssertEqual(patient.symptoms, "Symptoms")
        XCTAssertEqual(patient.medication, "Medication")
        XCTAssertEqual(patient.notes, "Notes")
    }
}

