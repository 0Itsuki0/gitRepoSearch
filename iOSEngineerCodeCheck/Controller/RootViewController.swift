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
    
    @IBOutlet weak var langButtonSelectAll: UIButton!
    
    @IBOutlet weak var langButtonC: UIButton!
    @IBOutlet weak var langButtonCPlusPlus: UIButton!
    @IBOutlet weak var langButtonCSharp: UIButton!
    @IBOutlet weak var langButtonGo: UIButton!
    @IBOutlet weak var langButtonJava: UIButton!
    @IBOutlet weak var langButtonJavaScript: UIButton!
    @IBOutlet weak var langButtonPHP: UIButton!
    @IBOutlet weak var langButtonRuby: UIButton!
    @IBOutlet weak var langButtonPython: UIButton!
    @IBOutlet weak var langButtonScala: UIButton!
    @IBOutlet weak var langButtonTypeScript: UIButton!
    @IBOutlet weak var langButtonOther: UIButton!
    
    private var langButtonList: [UIButton] = []
    
    
    private var repoList: [RepositoryModel] = []
    private var repoList_filtered: [RepositoryModel] = []
    

    
    private var idx: Int!
    
    private var repoDataManager = RepositoryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        langButtonList = [langButtonC, langButtonCPlusPlus, langButtonCSharp, langButtonGo, langButtonJava, langButtonJavaScript, langButtonPHP, langButtonRuby, langButtonPython, langButtonScala, langButtonTypeScript, langButtonOther]

        
        addBorderRoundCorner(toView: filterView as UIView, borderWidth: 2, cornerRadius: 10)
        addBorderRoundCorner(toView: starSwitch as UIView, borderWidth: 1, cornerRadius: starSwitch.layer.bounds.height/2)
        
        addBorderRoundCorner(toView: langButtonSelectAll as UIView, borderWidth: 1, cornerRadius: langButtonSelectAll.layer.bounds.height/2)
        
        
        /*
        addBorderRoundCorner(toView: langButtonC as UIView, borderWidth: 1, cornerRadius: langButtonC.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonCPlusPlus as UIView, borderWidth: 1, cornerRadius: langButtonCPlusPlus.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonCSharp as UIView, borderWidth: 1, cornerRadius: langButtonCSharp.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonGo as UIView, borderWidth: 1, cornerRadius: langButtonGo.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonJava as UIView, borderWidth: 1, cornerRadius: langButtonJava.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonJavaScript as UIView, borderWidth: 1, cornerRadius: langButtonJavaScript.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonPHP as UIView, borderWidth: 1, cornerRadius: langButtonPHP.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonRuby as UIView, borderWidth: 1, cornerRadius: langButtonRuby.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonPython as UIView, borderWidth: 1, cornerRadius: langButtonPython.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonScala as UIView, borderWidth: 1, cornerRadius: langButtonScala.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonTypeScript as UIView, borderWidth: 1, cornerRadius: langButtonTypeScript.layer.bounds.height/2)
        addBorderRoundCorner(toView: langButtonOther as UIView, borderWidth: 1, cornerRadius: langButtonOther.layer.bounds.height/2)
        */
        
        for button in langButtonList {
            addBorderRoundCorner(toView: button as UIView, borderWidth: 1, cornerRadius: button.layer.bounds.height/2)
        }
        
        // assigning self as the searchBarDelegate
        textField.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        repoDataManager.delegate = self
        
        tableView.accessibilityIdentifier = "RepoListTable"
        textField.accessibilityIdentifier = "textField"
        navigationController?.navigationBar.accessibilityIdentifier = "NavBar"
        filterView.accessibilityIdentifier = "filterView"
        starSwitch.accessibilityIdentifier = "starSwitch"
      
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
    
    
    @IBAction func LangFilterPress(_ sender: UIButton) {
        
        setButtonBackgroundColor(forButton: sender)
        
        if sender == langButtonSelectAll {
            for button in langButtonList {
                button.isSelected = sender.isSelected
                setButtonBackgroundColor(forButton: button)
            }
        }
        
        // manage list for filters selcted
        // TODO!!!
        
        
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

// MARK: - other helper functions

extension RootViewController {
    
    private func addBorderRoundCorner(toView view: UIView, borderWidth: CGFloat, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setButtonBackgroundColor(forButton button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.white
        }
        else {
            button.backgroundColor = UIColor.lightGray
        }
    }
}
