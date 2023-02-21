//
//  ApiEndpoint.swift
//  list the users
//
//  Created by Steven Hertz on 2/8/23.
//

import Foundation

enum ApiEndpoint {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    /// Define all your endpoints here
    case getUsers
    case getaUser(id: Int)
    case getStudents(uuid: String)
    case authenticateTeacher(company: String, username:String, password: String)
    case getSchoolClasses
    case addUser(username: String, password: String, email: String, firstName: String, lastName: String, locationId: Int)
    case deleteaUser(id: Int)
    case updateaUser(id: Int, username: String, password: String, email: String, firstName: String, lastName: String, locationId: Int)
    case getApps
    case getProfiles

}

extension ApiEndpoint {

    /// The path for every endpoint
    var path: String {
        switch self {
        case .getUsers:
           return "/users"
        case .getStudents(let uuid):
            return "/classes/\(uuid)"
        case .authenticateTeacher(company: _, username: _, password: _):
            return "/teacher/authenticate"
        case .getaUser(let id):
            return "/users/\(id)"
        case .getSchoolClasses:
            return "/classes"
        case .addUser:
            return "/users"
        case .deleteaUser(let id):
            return "/users/\(id)"
        case .updateaUser(let id, username: _, password: _, email: _, firstName: _, lastName: _, locationId: _):
            return "/users/\(id)"
        case .getApps:
            return "/apps"
        case .getProfiles:
            return "/profiles"
        }
    }
    
    /// The method for the endpoint
    var method: ApiEndpoint.Method {
        switch self {
        case .authenticateTeacher(company: _, username: _, password: _):
            return .POST
        case .addUser:
            return .POST
        case .updateaUser(id: _):
            return .PUT
        case .deleteaUser(id: _):
            return .DELETE
        default:
            return .GET
        }
    }
    
//    var requestHeaders: [String:String] {
//        switch self {
//        case .getUsers, .getStudents:
//            return ["Authorization": "Basic NjUzMTkwNzY6UFFMNjFaVUU2RlFOWDVKSlMzTE5CWlBDS1BETVhMSFA=",
//                    "Content-Type": "application/json",
//                    "X-Server-Protocol-Version": "2"
//            ]
//        case .getaUser(let id):
//            <#code#>
////        case .getStudents:
////            <#code#>
//        case .authenticateTeacher(let company, let username, let password):
//            <#code#>
//        case .getSchoolClasses:
//            <#code#>
//        case .addUser:
//            <#code#>
//        }
//    }
    
    /// The URL parameters for the endpoint (in case it has any)
    var parameters: [URLQueryItem]? {
        switch self {
//        case .getStudents(uuid: _):
//            return [URLQueryItem(name: "token", value: "9c74b8d6a4934ca986dfe46592896801")]
        default:
            return nil
        }
    }
}
