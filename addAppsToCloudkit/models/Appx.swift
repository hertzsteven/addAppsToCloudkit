//
//  App.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/16/23.
//

import Foundation
public struct Appi: Codable {
    public let id: Int
    public let locationId: Int
    public let isBook: Bool
    public let bundleId: String
    public let icon: URL
    public let name: String
    public let version: Date
    public let description: String
}
