//
//  User.swift
//  SoftwarePracticum
//
//  Created by Miriam Abecasis on 9/24/26.
//

import SwiftUI
import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var phone: String
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case name
            case phone
            case createdAt = "created_at"
        }
}

struct CreateUser: Codable {
    var name: String
    var phone: Int
}

struct UserLogin: Codable {
    var phone: Int
}
