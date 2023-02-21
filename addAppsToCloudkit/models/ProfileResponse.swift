//
//  ProfileResponse.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/20/23.
//

import Foundation

struct ProfileResponse: Codable {
    struct Profile: Codable {
        let id: Int
        let locationId: Int
//        struct `Type`: Codable {
//            let value: String
//        }
//        let type: Type
//        struct Status: Codable {
//            let value: String
//        }
//        let status: Status
        let identifier: String
        let name: String
        let description: String
//        let platform: String
//        let daysOfTheWeek: [Any] //TODO: Specify the type to conforms Codable protocol
//        let isTemplate: Bool
//        let startTime: Any? //TODO: Specify the type to conforms Codable protocol
//        let endTime: Any? //TODO: Specify the type to conforms Codable protocol
//        let useHolidays: Bool
//        let restrictedWeekendUse: Bool
    }
    let profiles: [Profile]
}
