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
    
    // carry repository list fetched
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel])
    
    // carry image data fetched
    func carryImgData(_ repositoryDataManager: RepositoryDataManager, didFetchImageData imgData: Data)
    
    //carry any error from API call
    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String)
}

extension RepositoryDataDelegate {
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]){}
    func carryImgData(_ repositoryDataManager: RepositoryDataManager, didFetchImageData imgData: Data){}
    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String){}
}
