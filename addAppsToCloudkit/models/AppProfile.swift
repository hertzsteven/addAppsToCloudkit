//
//  AppProfile.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/20/23.
//

import Foundation

struct AppProfile: Identifiable, Comparable {
    
    static func < (lhs: AppProfile, rhs: AppProfile) -> Bool {
          return lhs.name < rhs.name
      }
    
    var  id = UUID().uuidString
    var  appBundleId : String = ""
    var  locationId : Int  = 0
    var  category : String = ""
    var  profileName : String = ""
    var  name : String = ""
    var  description : String = ""
    var  iconURL: String = ""
}

class AppProfileViewModel: ObservableObject {
    @Published var appProfiles: [AppProfile] = []
    
//     init() {
//         // Initialize the appProfiles array with some sample data
//         self.appProfiles = [
//             AppProfile(appBundleId: "com.example.app1", locationId: 1, category: "Entertainment", profileName: "App 1 Profile", name: "App 1", description: "A cool app"),
//             AppProfile(appBundleId: "com.example.app2", locationId: 2, category: "Productivity", profileName: "App 2 Profile", name: "App 2", description: "A useful app"),
//            AppProfile(appBundleId: "com.example.app3", locationId: 3, category: "Games", profileName: "App 3 Profile", name: "App 3", description: "A fun app"),
//        ]
//    }
}
