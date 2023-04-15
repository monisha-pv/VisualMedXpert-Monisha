//
//  ScheduleScanModel.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/02/2023.
//

import Foundation

struct Scan: Codable, Hashable, Identifiable {
    
    var id: Int
    var name: String
    var email: String
    var gender: String
    var condition: String
    var scanType: String
    var centre: String
    var date: String
    var time: String
    
}
