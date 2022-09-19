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
    
    func fetchRepoData(_ userInput: String) {
        
        if userInput == "" {
            print("Empty user input")
            self.delegate?.carryError(self, didFailWithError: "Empty user input")
            return
        }
        
        let urlString =  repoSearchBaseURL + userInput
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            self.delegate?.carryError(self, didFailWithError: "Invalid User Input: \(userInput)")
            return
        }
        let _ = Task{() in
            do {
                try Task.checkCancellation()
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    
                    print("repo data fetch success")
                    let repoData = decodeRepoData(data)
                    self.delegate?.carryRepoData(self, didFetchRepoData: repoData ?? [])
                    
                } else if let error = error {
                    print("\(error)")
                    self.delegate?.carryError(self, didFailWithError: "\(error)")
                    return
                }}.resume()
                
                try Task.checkCancellation()
                
            } catch {
                print("Error in task cancellation")
                self.delegate?.carryError(self, didFailWithError: "Error in task cancellation")
                return
            }
        }

    }
    
    
    func decodeRepoData(_ data: Data) -> [RepositoryModel]?{
        let decoder = JSONDecoder()
        do {
            let dataDecoded = try decoder.decode(RepositoryList.self, from: data)
            // print(dataDecoded.items[0])
            return dataDecoded.items
        }
        catch {
            print("Error in data decoding")
            self.delegate?.carryError(self, didFailWithError: "Error in data decoding")
            return nil
        }
    }
    
    
    func fetchAvatarImage(from avatar_url: String?){
                
        guard let avatar_url = avatar_url, let url = URL(string: avatar_url) else {
            print("Bad Avatar URL")
            self.delegate?.carryError(self, didFailWithError: "Invalid Avatar URL")
            return
        }
        
        let _ = Task{() in
            do {
                try Task.checkCancellation()
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        print("image fetch success")
                        self.delegate?.carryImgData(self, didFetchImageData: data)
                    } else if let error = error {
                        print("\(error)")
                        self.delegate?.carryError(self, didFailWithError: "\(error)")
                        return
                    }
                }.resume()
                
                try Task.checkCancellation()
                
            } catch {
                print("Error in task cancellation")
                self.delegate?.carryError(self, didFailWithError: "Error in task cancellation")
                return
            }
        }
    }
    
    func openRepository(withURL url: String?) {
        guard let repoUrl_string = url, let url = URL(string: repoUrl_string) else {
            self.delegate?.carryError(self, didFailWithError: "Failed to open the repository")
            return
        }
        UIApplication.shared.open(url)
    }
    

}
