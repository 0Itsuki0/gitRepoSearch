//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/11.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryModel: Codable, Equatable {
    
    let id: Int
    let full_name: String?
    let owner: OwnerModel?
    let language: String?
    let stargazers_count: Int?
    let wachers_count: Int?
    let forks_count: Int?
    let open_issues_count: Int?

    var showStar: Bool {
        let stargazers_count = stargazers_count ?? 0
        if stargazers_count > K.starThreshold {
            return true
        }
        else {
            return false
        }
    }
    
    struct OwnerModel: Codable, Equatable {
        let avatar_url: String?
    }
}

/*
extension RepositoryModel {
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      name = try container.decode(String.self, forKey: .name)
      city = try container.decode(String.self, forKey: .city)
      country = try container.decode(String.self, forKey: .country)
      date = try container.decode(String.self, forKey: .date)
      days = try container.decode(Int.self, forKey: .days)
      isOnline = (try? container.decode(Bool.self, forKey: .isOnline)) ?? false
    }
}
*/
