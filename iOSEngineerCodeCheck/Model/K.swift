//
//  K.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit



struct K {
    
    static let starThreshold: Int = 1000
    
    static let repoSearchBaseURL: String = "https://api.github.com/search/repositories?q="

    enum languages: String, CaseIterable {
        case langC = "C"
        case langCPlusPlus = "C++"
        case CSharp = "C#"
        case langGo = "Go"
        case langJava = "Java"
        case langJavaScript = "JavaScript"
        case langPHP = "PHP"
        case langPython = "Python"
        case langRuby = "Ruby"
        case langScala = "Scala"
        case langTypeScript = "TypeScript"
    }
    
    enum sortType: String {
        case byNewest = "Newest"
        case byOldest = "Oldest"
        case byAscendingStar = "Ascending"
        case byDescendingStar = "Descending"
        case noSort = "NoSort"
    }
}
