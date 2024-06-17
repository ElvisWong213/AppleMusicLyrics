//
//  UserStorefront.swift
//  
//
//  Created by Elvis on 12/06/2024.
//

import Foundation

struct UserStorefront: Codable {
    let data: [UserStorefrontData]?
}

struct UserStorefrontData: Codable {
    let id: String?
    let type: String?
    let href: String?
    let attributes: UserStorefrontAttributes?
}

struct UserStorefrontAttributes: Codable {
    let supportedLanguageTags: [String]?
    let defaultLanguageTag: String?
    let name: String?
    let explicitContentPolicy: String?
}
