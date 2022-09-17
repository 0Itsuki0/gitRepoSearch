//
//  RepositoryDataDelegate.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/10.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit


protocol RepositoryDataDelegate {
    func carryRepoData(_ repoData: [RepositoryModel])
    func carryImgData(_ imgData: Data)
    func carryError(_ error: String)
}

extension RepositoryDataDelegate {
    func carryRepoData(_ repoData: [RepositoryModel]){}
    func carryImgData(_ imgData: Data){}
    func carryError(_ error: String){}
}
