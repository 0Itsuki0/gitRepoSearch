//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
   
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var starSwitch: UISwitch!
    
    var repoList: [RepositoryModel] = []
    var repoList_filtered: [RepositoryModel] = []
    

    
    var idx: Int!
    
    var repoDataManager = RepositoryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterView.layer.cornerRadius = 10
        filterView.layer.masksToBounds = true
        filterView.layer.borderWidth = 2
        filterView.layer.borderColor = UIColor.white.cgColor
        
        starSwitch.layer.cornerRadius = starSwitch.layer.bounds.height/2
        starSwitch.layer.masksToBounds = true
        starSwitch.layer.borderWidth = 1
        starSwitch.layer.borderColor = UIColor.white.cgColor
                   
        // assigning self as the searchBarDelegate
        textField.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        repoDataManager.delegate = self
        
        tableView.accessibilityIdentifier = "RepoListTable"
        textField.accessibilityIdentifier = "textField"
        navigationController?.navigationBar.accessibilityIdentifier = "NavBar"
      
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

    }
    
    
    @IBAction func SearchButtonClick(_ sender: Any) {
        textField.endEditing(true)
        
        if let word = textField.text {
            print(word)
            repoDataManager.fetchRepoData(word)
            textField.text = ""
        }
        
    }
    
    @IBAction func FilterOptionButtonClick(_ sender: Any) {
        filterView.isHidden = !filterView.isHidden
    }
    
    @IBAction func starSwitchPress(_ sender: Any) {
        repoList_filtered = repoList.filter { repo in
            (!self.starSwitch.isOn || repo.showStar)
        }
        tableView.reloadData()
        
        
        if (repoList_filtered.count == 0 && starSwitch.isOn) {
            let alert = UIAlertController(title: "Warning", message: "No matching starred repository", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
 
    }
    
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        textField.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RootToDetail"{
            let dtl = segue.destination as! DetailViewController
            dtl.repo = self.repoList_filtered[idx]
        }
    }
}


// MARK: - tableViewController functions

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList_filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TableViewCell
        let rp = repoList_filtered[indexPath.row]
        cell.repoTitleLabel.text = rp.full_name ?? ""
        cell.repoLanguageLabel.text = rp.language ?? ""
        cell.starImage.isHidden = !rp.showStar
        cell.tag = indexPath.row
        cell.accessibilityIdentifier = String(indexPath.row)
        return cell
        
    }
    
    // when a row is selected, move to the detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        performSegue(withIdentifier: "RootToDetail", sender: self)
    }
}


// MARK: - textField Delegate functions

extension RootViewController: UITextFieldDelegate {
    
    // return button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        if let word = textField.text {
            print(word)
            repoDataManager.fetchRepoData(word)
            textField.text = ""
        }
        
        return true
    }
    
}

// MARK: - RepositoryDataDelegate functions

extension RootViewController: RepositoryDataDelegate {
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]) {
        DispatchQueue.main.async {
            self.repoList = repoData
            self.repoList_filtered = self.repoList.filter { repo in
                (!self.starSwitch.isOn || repo.showStar)
            }
            self.tableView.reloadData()

            if (self.repoList.count == 0) {
                let alert = UIAlertController(title: "Warning", message: "No maching", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
            else if (self.repoList_filtered.count == 0 && self.repoList.count != 0) {
                let alert = UIAlertController(title: "Warning", message: "No starred repository matching; non stared repository found", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
    }

    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String) {
        // create the alert
        let alert = UIAlertController(title: "Warning", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
