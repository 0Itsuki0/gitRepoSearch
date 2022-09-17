//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    @IBOutlet weak var SchBr: UISearchBar!
    
    var repoList: [RepositoryModel] = []
    var idx: Int!
    
    var repoDataManager = RepositoryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assigning self as the searchBarDelegate
        SchBr.delegate = self
        repoDataManager.delegate = self
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RootToDetail"{
            let dtl = segue.destination as! DetailViewController
            dtl.repo = self.repoList[idx]
        }
    }
}


// functions as UITableViewController
extension RootViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let rp = repoList[indexPath.row]
        cell.textLabel?.text = rp.full_name ?? ""
        cell.detailTextLabel?.text = rp.language ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    // when a row is selected, move to the detail page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        performSegue(withIdentifier: "RootToDetail", sender: self)
    }
}


// functions as UISearchBarDelegate
extension RootViewController: UISearchBarDelegate {
    
    // return button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    // fetch result for an user input
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // fetch request
        if let word = searchBar.text {
            print(word)
            repoDataManager.fetchRepoData(word)
            searchBar.text = ""
        }
    }
}


extension RootViewController: RepositoryDataDelegate {
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]) {
        DispatchQueue.main.async {
            self.repoList = repoData
            self.tableView.reloadData()
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
