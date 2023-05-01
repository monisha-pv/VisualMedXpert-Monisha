//
//  ManagePatientTests.swift
//  VisualMedXpertTests
//
//  Created by Monisha Vadivelu on 01/05/2023.
//

import XCTest
import SwiftUI

@testable import VisualMedXpert

class ManagePatientViewTests: XCTestCase {
    
    func testGetPatients() {
        let session = URLSession(configuration: .default)
        let viewModel = DoctorView()
        let mockData = "[{\"id\":3,\"fullname\":\"Rebecca Peterson\",\"dob\":\"17/03/1988\",\"gender\":\"Female\",\"nhsNo\":\"P00000\",\"address\":\"111 Green Street, IG3 3PX\",\"medcondition\":\"Blood Cancer\",\"patientdescription\":\"Louise has been suffering with blooc cancer for 13 years\",\"symptoms\":\"Paleness\",\"medication\":\"Cyclomide\",\"notes\":\"Blood test due in 5 days\"}]"
        let url = URL(string: "http://10.212.78.114:8000/patients/")!
        
        // Register MockURLProtocol for URL
        MockURLProtocol.mockResponses[url] = mockData.data(using: .utf8)
        URLProtocol.registerClass(MockURLProtocol.self)
        
        // Test getPatients function
        viewModel.getPatients()
    }
}


class MockURLProtocol: URLProtocol {
    
    // This dictionary maps URLs to mock responses
    static var mockResponses: [URL: Data] = [:]
    
    // Override this function to intercept network requests
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // Override this function to return the mock response
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // Override this function to return the mock response data
    override func startLoading() {
        if let data = MockURLProtocol.mockResponses[request.url!] {
            let response = URLResponse(url: request.url!, mimeType: nil, expectedContentLength: data.count, textEncodingName: nil)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    // Override this function to do nothing
    override func stopLoading() {}
    
}


