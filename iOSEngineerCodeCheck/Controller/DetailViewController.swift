//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var TtlLbl: UILabel!
    
    @IBOutlet weak var LangLbl: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    @IBOutlet weak var StrsLbl: UILabel!
    @IBOutlet weak var WchsLbl: UILabel!
    @IBOutlet weak var FrksLbl: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    @IBOutlet weak var gitHubOpenButton: UIButton!
    
    
    var repo: RepositoryModel!
    var repoDataManager = RepositoryDataManager()

        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // assign self as the repoDataDelegate
        repoDataManager.delegate = self
        
        // give identifiers to views
        ImgView.accessibilityIdentifier = "AvatarImage"
        
        TtlLbl.accessibilityIdentifier = "TitleLabel"
        starImageView.accessibilityIdentifier = "starImage"
        
        LangLbl.accessibilityIdentifier = "LanguageLabel"
        updatedDateLabel.accessibilityIdentifier = "updatedDateLabel"
        
        StrsLbl.accessibilityIdentifier = "StarsLabel"
        WchsLbl.accessibilityIdentifier = "WatchesLabel"
        FrksLbl.accessibilityIdentifier = "ForksLabel"
        IsssLbl.accessibilityIdentifier = "IssuesLabel"
        
        gitHubOpenButton.accessibilityIdentifier = "gitHubOpenButton"
        
        // update image
        repoDataManager.fetchAvatarImage(from: repo.owner?.avatar_url)
        
        // update labels
        TtlLbl.text = repo.full_name ?? "(Untitled)"
        starImageView.isHidden = !repo.showStar

        LangLbl.text = "Written in \(repo.language ?? "(Unspecified)" )"
        updatedDateLabel.text = "Latest Update: " + repoDataManager.formatDateTime(dateTimeString: repo.updated_at ?? "")

        StrsLbl.text = "\(repo.stargazers_count ?? 0) stars"
        WchsLbl.text = "\(repo.wachers_count ?? 0) watchers"
        FrksLbl.text = "\(repo.forks_count ?? 0) forks"
        IsssLbl.text = "\(repo.open_issues_count ?? 0) open issues"
    }
    
    
    @IBAction func openGitHubButtonPress(_ sender: Any) {
        repoDataManager.openRepository(withURL: repo.html_url)
    }
    
    
}


// MARK: - RepositoryDataDelegate functions

extension DetailViewController: RepositoryDataDelegate {
    func carryImgData(_ repositoryDataManager: RepositoryDataManager, didFetchImageData imgData: Data) {
        DispatchQueue.main.async {
            let img = UIImage(data: imgData) ?? UIImage(systemName: "face.smiling")
            self.ImgView.image = img
        }
    }
    
    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String) {
        // create the alert
        let alert = UIAlertController(title: "Warning", message: error, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.ImgView.image = UIImage(systemName: "face.smiling")
            self.present(alert, animated: true)
        }
    }
}
