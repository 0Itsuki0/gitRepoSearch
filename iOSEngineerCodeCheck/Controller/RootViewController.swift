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
    
    @IBOutlet weak var filterViewButton: UIButton!
    
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
    
    @IBOutlet weak var sortNewestButton: UIButton!
    @IBOutlet weak var sortOldestButton: UIButton!
    
    @IBOutlet weak var sortAscendingButton: UIButton!
    @IBOutlet weak var sortDescendingButton: UIButton!
    
    private var langButtonList: [UIButton] = []
    private var sortingButtonList: [UIButton] = []
    
    private var repoList_original: [RepositoryModel] = []
    private var repoList_filteredSorted: [RepositoryModel] = []
    
    private var idx: Int!
    
    private var repoDataManager = RepositoryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        langButtonList = [langButtonC, langButtonCPlusPlus, langButtonCSharp, langButtonGo, langButtonJava, langButtonJavaScript, langButtonPHP, langButtonRuby, langButtonPython, langButtonScala, langButtonTypeScript, langButtonOther]
        sortingButtonList = [sortNewestButton, sortOldestButton, sortAscendingButton, sortDescendingButton]
        
        // assigning delegates
        textField.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        repoDataManager.delegate = self
        
        // modify appearance
        addBorderRoundCorner(toView: filterView as UIView, borderWidth: 2, cornerRadius: 10)
        addBorderRoundCorner(toView: starSwitch as UIView, borderWidth: 1, cornerRadius: starSwitch.layer.bounds.height/2)
        
        addBorderRoundCorner(toView: langButtonSelectAll as UIView, borderWidth: 1, cornerRadius: langButtonSelectAll.layer.bounds.height/2)
        setButtonBackgroundColor(forButton: langButtonSelectAll)
        langButtonSelectAll.accessibilityIdentifier = "langButtonSelectAll"
        
        for button in langButtonList {
            addBorderRoundCorner(toView: button as UIView, borderWidth: 1, cornerRadius: button.layer.bounds.height/2)
            setButtonBackgroundColor(forButton: button)
            button.accessibilityIdentifier = button.titleLabel?.text
        }
        
        addBorderRoundCorner(toView: sortNewestButton as UIView, borderWidth: 1, cornerRadius: sortNewestButton.layer.bounds.height/2)
        setButtonBackgroundColor(forButton: sortNewestButton)
        
        addBorderRoundCorner(toView: sortOldestButton as UIView, borderWidth: 1, cornerRadius: sortOldestButton.layer.bounds.height/2)
        setButtonBackgroundColor(forButton: sortOldestButton)
        
        addBorderRoundCorner(toView: sortAscendingButton as UIView, borderWidth: 1, cornerRadius: sortAscendingButton.layer.bounds.height/2)
        setButtonBackgroundColor(forButton: sortAscendingButton)
        
        addBorderRoundCorner(toView: sortDescendingButton as UIView, borderWidth: 1, cornerRadius: sortDescendingButton.layer.bounds.height/2)
        setButtonBackgroundColor(forButton: sortDescendingButton)
        
        tableView.accessibilityIdentifier = "RepoListTable"
        textField.accessibilityIdentifier = "textField"
        navigationController?.navigationBar.accessibilityIdentifier = "NavBar"
        filterView.accessibilityIdentifier = "filterView"
        starSwitch.accessibilityIdentifier = "starSwitch"
      
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

    }
    
    // search button press
    @IBAction func SearchButtonPress(_ sender: Any) {
        
        textField.endEditing(true)
        
        if let word = textField.text {
            print(word)
            repoDataManager.fetchRepoData(word)
            textField.text = ""
        }
    }
    
    // filter and sorting options
    @IBAction func FilterOptionButtonClick(_ sender: Any) {
        filterView.isHidden = !filterView.isHidden
    }
    
    // show/hide unstarred repo
    @IBAction func starSwitchPress(_ sender: Any) {
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, sortType: getSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if (repoList_filteredSorted.count == 0 && starSwitch.isOn) {
            showAlert(withMessage: "No matching starred repository")
        }
 
    }
    
    // filter list by language selected
    @IBAction func LangFilterPress(_ sender: UIButton) {
        
        setButtonBackgroundColor(forButton: sender)
        
        if sender == langButtonSelectAll {
            for button in langButtonList {
                button.isSelected = sender.isSelected
                setButtonBackgroundColor(forButton: button)
            }
        } else if (!sender.isSelected) {
            langButtonSelectAll.isSelected = false
            setButtonBackgroundColor(forButton: langButtonSelectAll)
        }
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, sortType: getSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // sort list by selected option
    @IBAction func sortButtonPress(_ sender: UIButton) {
        setButtonBackgroundColor(forButton: sender)
        
        if (sender.isSelected) {
            deselectSortButton(sortOnButton: sender)
        }
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, sortType: getSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // hide keyboard
    @IBAction func tapGestureRecognized(_ sender: Any) {
        textField.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RootToDetail"{
            let dtl = segue.destination as! DetailViewController
            dtl.repo = self.repoList_filteredSorted[idx]
        }
    }
}



// MARK: - tableViewController functions

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList_filteredSorted.count
    }
    
    // create tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TableViewCell
        let rp = repoList_filteredSorted[indexPath.row]
        
        cell.repoTitleLabel.text = rp.full_name ?? ""
        cell.repoLanguageLabel.text = "Language: " + (rp.language ?? "(Unspecified)")
        cell.repoUpdateDateLabel.text = "Latest Update: " + repoDataManager.formatDateTime(dateTimeString: rp.updated_at ?? "")
        cell.starImage.isHidden = !rp.showStar
        cell.starCount.text = "\(rp.stargazers_count ?? 0) stars"
        
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
    
    // handle data fetched from API Call
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]) {
        
        DispatchQueue.main.async { [self] in
            repoList_original = repoData
            repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, sortType: getSortType())
            
            tableView.reloadData()
            
            if (repoList_original.count == 0) {
                showAlert(withMessage: "No Matching")
            } else if (repoList_filteredSorted.count == 0 && repoList_original.count != 0) {
                showAlert(withMessage: "No repository matching for the given filter")
            }
            
        }
    }

    // handle error from API Call
    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String) {
        DispatchQueue.main.async {
            self.showAlert(withMessage: error)
        }
    }
}

// MARK: - other helper functions

extension RootViewController {
    
    // modify vieww: round corner and add border
    private func addBorderRoundCorner(toView view: UIView, borderWidth: CGFloat, cornerRadius: CGFloat) {
        
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        
    }
    
    // function for toggle appearance of buttons based on the state
    private func setButtonBackgroundColor(forButton button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.white
        }
        else {
            button.backgroundColor = UIColor.lightGray
        }
    }
    
    // get current sort type
    private func getSortType() -> K.sortType {
        
        if sortNewestButton.isSelected {
            return K.sortType.byNewest
        } else if sortOldestButton.isSelected {
            return K.sortType.byOldest
        } else if sortAscendingButton.isSelected {
            return K.sortType.byAscendingStar
        } else if sortDescendingButton.isSelected {
            return K.sortType.byDescendingStar
        } else {
            return K.sortType.noSort
        }
    }
    
    // only one type of sort is allowed
    private func deselectSortButton(sortOnButton: UIButton) {
        
        for button in sortingButtonList {
            if button != sortOnButton {
                button.isSelected = false
                setButtonBackgroundColor(forButton: button)
            }
        }
    }
    
    // create and show alert for given message
    private func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
        
    }
}
