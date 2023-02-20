//
//  addAppsToCloudkitApp.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/16/23.
//

import SwiftUI

@main
struct addAppsToCloudkitApp: App {
    
    var appWork: AppWork = AppWork()
    
    var body: some Scene {
        WindowGroup {
            PersonListView()
                .environmentObject(appWork)
        }
    }
}
