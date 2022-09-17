//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/11.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryModel: Codable {
    
    var id: Int
    var full_name: String?
    let owner: OwnerModel?
    var language: String?
    var stargazers_count: Int?
    var wachers_count: Int?
    var forks_count: Int?
    var open_issues_count: Int?

    struct OwnerModel: Codable {
        var avatar_url: String?
    }
}


