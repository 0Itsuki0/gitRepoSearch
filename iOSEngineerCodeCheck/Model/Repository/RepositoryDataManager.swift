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
    
    
    private func decodeRepoData(_ data: Data) -> [RepositoryModel]?{
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
    
    
    func manageRepoList(starSwitch: UISwitch, langButtons: [UIButton], repoList: [RepositoryModel], dateSortType: K.sortTypeDate, starSortType: K.sortTypeCount) -> [RepositoryModel] {
        
        let repoList_filtered = filterRepoList(starSwitch: starSwitch, langButtons: langButtons, repoList: repoList)
        let repoList_sorted_date = sortRepoListByUpdateDate(sortType: dateSortType, repoList: repoList_filtered)
        let repoList_sorted_count = sortRepoListByStarCount(sortType: starSortType, repoList: repoList_sorted_date)
        
        return repoList_sorted_count
    }
    
    
    private func filterRepoList(starSwitch: UISwitch, langButtons: [UIButton], repoList: [RepositoryModel]) -> [RepositoryModel] {
        
        var repoList_filtered = repoList
        
        repoList_filtered = repoList_filtered.filter { repo in
            (!starSwitch.isOn || repo.showStar)
        }
    
        var tempList: [RepositoryModel] = []
        
        for langButton in langButtons {
            if langButton.isSelected == true {
                if langButton.titleLabel?.text != "Other" {
                    tempList = tempList + repoList_filtered.filter { $0.language == langButton.titleLabel?.text }
                } else {
                    tempList = tempList + repoList_filtered.filter { repo in
                        !K.languages.allCases.contains(where: { $0.rawValue == (repo.language ?? "")})
                    }
                }
            }
        }
        
        
        repoList_filtered = tempList
        return repoList_filtered
    }
    
    private func sortRepoListByUpdateDate(sortType: K.sortTypeDate, repoList: [RepositoryModel]) -> [RepositoryModel] {
        var sortedList: [RepositoryModel] = []
        switch sortType {
        case .byNewest:
            sortedList = repoList.sorted(by: {
                self.stringToDate(dateTimeString: $0.updated_at) > self.stringToDate(dateTimeString: $1.updated_at)})
        case .byOldest:
            sortedList = repoList.sorted(by: {
                self.stringToDate(dateTimeString: $0.updated_at) < self.stringToDate(dateTimeString: $1.updated_at)})
        default:
            sortedList = repoList
        }
        return sortedList
    }
    
    private func sortRepoListByStarCount(sortType: K.sortTypeCount, repoList: [RepositoryModel]) -> [RepositoryModel] {
        var sortedList: [RepositoryModel] = []
        switch sortType {
        case .Ascending:
            sortedList = repoList.sorted(by: { ($0.stargazers_count ?? 0) < ($1.stargazers_count ?? 0) })
        case .Descending:
                sortedList = repoList.sorted(by: { ($0.stargazers_count ?? 0) > ($1.stargazers_count ?? 0) })
        default:
            sortedList = repoList
        }
        return sortedList
    }
    
    
    
    // format time string in yyyy-MM-ddTHH:mm:ssZ format to yyyy/MM/dd format
    func formatDateTime(dateTimeString: String) -> String {
        let formatter_StringToDate = DateFormatter()
        formatter_StringToDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let time_dateTime = formatter_StringToDate.date(from: dateTimeString)
        
        guard let time_dateTime = time_dateTime else {
            return "(Unknown)"
        }
        
        let formatter_DateToString = DateFormatter()
        formatter_DateToString.dateFormat = "yyyy/MM/dd"
        let formattedDateTime = formatter_DateToString.string(from: time_dateTime)
        
        return formattedDateTime
    }
    
    private func stringToDate(dateTimeString: String?) -> Date {
        guard let dateTimeString = dateTimeString else {
            return Date(timeIntervalSince1970: TimeInterval(0))
        }
        let formatter_StringToDate = DateFormatter()
        formatter_StringToDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let time_dateTime = formatter_StringToDate.date(from: dateTimeString)
        return time_dateTime ?? Date(timeIntervalSince1970: TimeInterval(0))
    }
    
    
}
