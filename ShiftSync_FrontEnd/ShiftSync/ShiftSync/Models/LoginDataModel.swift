//
//  LoginDataModel.swift
//  ShiftSync
//
//  Created by Nidhi Khanpara on 2023-12-21.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let message: String
    let userData: User_Data

    enum CodingKeys: String, CodingKey {
        case message
        case userData = "user_data"
    }
}

// MARK: - UserData
struct User_Data: Codable {
    let id, address: String
    let age: String
    let availabilityID, email, firstName, lastName: String
    let password, username: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case address, age
        case availabilityID = "availability_id"
        case email, firstName, lastName, password, username
    }
}
