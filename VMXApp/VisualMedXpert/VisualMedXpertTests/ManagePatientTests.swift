//
//  ManagePatientTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 01/05/2023.
//

import XCTest
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@testable import VisualMedXpert

class ManagePatientTests: XCTestCase {

    func testGetPatients() {

        let doctorView = DoctorView()
        let expectation = XCTestExpectation(description: "Fetch patients")
        

        doctorView.getPatients()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertGreaterThan(doctorView.patients.count, 0, "No patients found")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testPatientAddView() {
        let doctorView = DoctorView()
        let expectation = XCTestExpectation(description: "Add new patient")
        let patientAddView = PatientAddView(function: {
            doctorView.getPatients()
            expectation.fulfill()
        })
        
        
        patientAddView.fullname = "John Smith"
        patientAddView.dob = "01/01/1990"
        patientAddView.gender = "Male"
        patientAddView.nhsNo = "1234567890"
        patientAddView.address = "123 Main St"
        patientAddView.medcondition = "Flu"
        patientAddView.patientdescription = "Symptoms include coughing and fever"
        patientAddView.symptoms = "Coughing, fever"
        patientAddView.medication = "Tylenol"
        patientAddView.notes = "Prescribed rest and fluids"
        
        patientAddView.postPatients()
        

        wait(for: [expectation], timeout: 20.0)
        XCTAssertGreaterThan(doctorView.patients.count, 0, "New patient not added")
    }
}



