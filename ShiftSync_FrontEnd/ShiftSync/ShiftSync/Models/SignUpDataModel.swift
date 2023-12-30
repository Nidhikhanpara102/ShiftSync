//
//  SignUpDataModel.swift
//  ShiftSync
//
//  Created by Nidhi Khanpara on 2023-12-21.
//


import Foundation

// MARK: - SignUpDataModel
struct SignUpDataModel: Codable {
    let availabilityData: AvailabilityData
    let message: String
    let userData: UserData

    enum CodingKeys: String, CodingKey {
        case availabilityData = "availability_data"
        case message
        case userData = "user_data"
    }
}

// MARK: - AvailabilityData
struct AvailabilityData: Codable {
    let friday, monday, saturday, sunday: String?
    let thursday, tuesday, wednesday: String?

    enum CodingKeys: String, CodingKey {
        case friday = "Friday"
        case monday = "Monday"
        case saturday = "Saturday"
        case sunday = "Sunday"
        case thursday = "Thursday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
    }
}

// MARK: - UserData
struct UserData: Codable {
    let address: String
    let age: String
    let email, firstName, lastName, password: String
    let username: String
}
