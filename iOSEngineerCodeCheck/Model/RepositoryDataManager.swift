//
//  RepositoryDataManager.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/10.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

struct RepositoryDataManager {
    
    let repoSearchBaseURL: String = "https://api.github.com/search/repositories?q="
    var delegate: RepositoryDataDelegate?
    
    func searchFor(_ userInput: String) {
        
        if userInput == "" {
            print("Empty user input")
            self.delegate?.carryError("Empty user input")
            return
        }
        
        let urlString =  repoSearchBaseURL + userInput
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            self.delegate?.carryError("Invalid User Input: \(userInput)")
            return
        }
        let _ = Task{() in
            do {
                try Task.checkCancellation()
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    
                    print("repo data fetch success")
                    let repoData = decodeRepoData(data)
                    self.delegate?.carryRepoData(repoData)
                    
                } else if let error = error {
                    print("\(error)")
                    self.delegate?.carryError("\(error)")
                    return
                }}.resume()
                
                try Task.checkCancellation()
                
            } catch {
                print("Error in task cancellation")
                self.delegate?.carryError("Error in task cancellation")
                return
            }
        }

    }
    
    
    func decodeRepoData(_ data: Data) -> [RepositoryModel]{
        let decoder = JSONDecoder()
        do {
            let dataDecoded = try decoder.decode(RepositoryList.self, from: data)
            // print(dataDecoded.items[0])
            return dataDecoded.items
        }
        catch {
            print("Error in data decoding")
            self.delegate?.carryError("Error in data decoding")
            return []
        }
    }
    
    
    func fetchAvatarImage(from avatar_url: String?){
                
        guard let avatar_url = avatar_url, let url = URL(string: avatar_url) else {
            print("Bad Avatar URL")
            return
        }
        let _ = Task{() in
            do {
                try Task.checkCancellation()
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        print("image fetch success")
                        self.delegate?.carryImgData(data)
                    } else if let error = error {
                        print("\(error)")
                        self.delegate?.carryError("\(error)")
                        return
                    }
                }.resume()
                
                try Task.checkCancellation()
                
            } catch {
                print("Error in task cancellation")
                self.delegate?.carryError("Error in task cancellation")
                return
            }
        }
        

                
    }

}
