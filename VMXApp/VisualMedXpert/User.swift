//
//  User.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 16/03/2023.
//

import Foundation

struct User: Hashable {
    var uid: String?
    var email: String?
    var displayName: String?
    
    init(uid: String?, email: String?, displayName: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}
