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
    
    @IBOutlet weak var sortNewestButton: UIButton!
    @IBOutlet weak var sortOldestButton: UIButton!
    
    @IBOutlet weak var sortAscendingButton: UIButton!
    @IBOutlet weak var sortDescendingButton: UIButton!
    
    var langButtonList: [UIButton] = []
    var sortingButtonList: [UIButton] = []
    
    private var repoList_original: [RepositoryModel] = []
    private var repoList_filteredSorted: [RepositoryModel] = []
    
    private var idx: Int!
    
    private var repoDataManager = RepositoryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        langButtonList = [langButtonC, langButtonCPlusPlus, langButtonCSharp, langButtonGo, langButtonJava, langButtonJavaScript, langButtonPHP, langButtonRuby, langButtonPython, langButtonScala, langButtonTypeScript, langButtonOther]
        sortingButtonList = [sortNewestButton, sortOldestButton, sortAscendingButton, sortDescendingButton]
        
        // assigning self as delegates
        textField.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        repoDataManager.delegate = self
        
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
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if (repoList_filteredSorted.count == 0 && starSwitch.isOn) {
            showAlert(withMessage: "No matching starred repository")
        }
 
    }
    
    
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
        
        // manage list for filters selcted
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
 
    
    @IBAction func sortByNewestButtonPress(_ sender: UIButton) {
        setButtonBackgroundColor(forButton: sender)
        
        if (sender.isSelected) {
            deselectSortButton(sortOnButton: sender)
        }
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func sortByOldestButtonPress(_ sender: UIButton) {
        
        setButtonBackgroundColor(forButton: sender)
        
        if (sender.isSelected) {
            deselectSortButton(sortOnButton: sender)
        }
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func sortByAscendingStarButtonPress(_ sender: UIButton) {
        
        setButtonBackgroundColor(forButton: sender)
        
        if (sender.isSelected) {
            deselectSortButton(sortOnButton: sender)
        }
        
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func sortByDescendingStarButtonPress(_ sender: UIButton) {
        setButtonBackgroundColor(forButton: sender)
        if (sender.isSelected) {
            deselectSortButton(sortOnButton: sender)
        }
        repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
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
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]) {
        DispatchQueue.main.async { [self] in
            repoList_original = repoData
            repoList_filteredSorted = repoDataManager.manageRepoList(starSwitch: starSwitch, langButtons: langButtonList, repoList: repoList_original, dateSortType: getDateSortType(), starSortType: getCountSortType())
            tableView.reloadData()
            
            if (repoList_original.count == 0) {
                showAlert(withMessage: "No Matching")
            } else if (repoList_filteredSorted.count == 0 && repoList_original.count != 0) {
                showAlert(withMessage: "No repository matching for the given filter")
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
    
    private func getDateSortType() -> K.sortTypeDate {
        
        if sortNewestButton.isSelected {
            return K.sortTypeDate.byNewest
        } else if sortOldestButton.isSelected {
            return K.sortTypeDate.byOldest
        } else {
            return K.sortTypeDate.noSort
        }
    }
    
    private func getCountSortType() -> K.sortTypeCount {
        
        if sortAscendingButton.isSelected {
            return K.sortTypeCount.Ascending
        } else if sortDescendingButton.isSelected {
            return K.sortTypeCount.Descending
        } else {
            return K.sortTypeCount.noSort
        }
    }
    
    private func deselectSortButton(sortOnButton: UIButton) {
        for button in sortingButtonList {
            if button != sortOnButton {
                button.isSelected = false
                setButtonBackgroundColor(forButton: button)
            }
        }
    }
    
    
    private func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
        
    }
}
