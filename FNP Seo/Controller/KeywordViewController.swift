//
//  KeywordViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import UIKit
import RealmSwift

class KeywordViewController: UITableViewController {
    
    @IBOutlet weak var alexaResultLabel: UILabel!
    
    let realm = try! Realm()
    var keywordModel = KeywordModel()
    var seo = SEO()
    
    var keyword: Results<Keywords>?
    var selectedDomain: WebSites? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        seo.delegate = self
        print(keywordModel.keywordNames)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        var keywordArray = [String]()
        keywordModel.keywordNames.forEach { keyword in
            keywordArray.append(keyword)
        }
        keywordModel.keywordNames = [String]()
        keywordModel.keywordRanks = [Double]()
        
        keywordArray.forEach { keyword in
            self.seo.fetchSEO(keyword: keyword, requestURL: self.selectedDomain!.domainName)
        }
      
        refreshControl?.endRefreshing()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Keyword", message: "Please specify and add your keyword to achive seo rank.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let textSafe = text.text {
                let textPrefix = textSafe.removeWhitespace()
                
                if self.keywordModel.keywordNames.count > 0 {
                    if self.keywordModel.keywordNames.contains(textSafe) {
                        return
                    } else {
                        self.seo.fetchSEO(keyword: textPrefix, requestURL: self.selectedDomain!.domainName, start: 1)
                    }
                } else {
                    self.seo.fetchSEO(keyword: textPrefix, requestURL: self.selectedDomain!.domainName, start: 1)
                }
            }
        }
                
        alert.addAction(action)
        alert.addTextField { textfield in
            text = textfield
            textfield.placeholder = "Type a keyword..."
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return selectedDomain!.keywords.count
        }      
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Statistics"
        } else if section == 1 {
            return "Keywords"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keywordCell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.keywordCell, for: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            keywordCell.detailTextLabel?.text = keywordModel.averageRankString
            keywordCell.textLabel?.text = "Average Ranking"
        } else if indexPath.section == 0 && indexPath.row == 1 {
            keywordCell.detailTextLabel?.text = keywordModel.keywordCountString
            keywordCell.textLabel?.text = "Total Keywords"
        }
        
        if 0 < keywordModel.keywordRanks.count  && 0 < keywordModel.keywordNames.count && indexPath.section == 1 {
            keywordCell.detailTextLabel?.text = String(keywordModel.keywordRanks[indexPath.row])
            keywordCell.textLabel?.text = keywordModel.keywordNames[indexPath.row]
        }
        return keywordCell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.keywordToLinks, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LinkListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.keywordRaw = selectedDomain?.keywords[indexPath.row].name
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                deleteData(indexPath: indexPath)
            }
        }
    }
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "date", ascending: true)
        
        statisticCalculate(keyword: keyword)
        tableView.reloadData()
    }
    
    func statisticCalculate(keyword: Results<Keywords>?) {
        keywordModel.averageOfRanks(resultKeyword: keyword)
        keywordModel.saveKeywords(from: keyword)
    }
    
    func saveData(keyword: Keywords) {
        do {
            try realm.write {
                realm.add(keyword)
            }
        } catch {
            didFailWithError(error: error)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deleteData(indexPath: IndexPath?) {
        do {
            try realm.write {
                realm.delete(selectedDomain!.keywords[indexPath!.row])
            }
        } catch {
            print("Error delete keyword: \(error)")
        }
        keywordModel.keywordRanks.removeLast()
        keywordModel.keywordNames.removeLast()
        loadData()
    }
}

//MARK: - SEO Delegate

extension KeywordViewController: SEODelegate {
    
    func seoModel(link: String, url: String, listLine: Int, keyword: String) {
        DispatchQueue.main.async {
            do {
                try self.realm.write({
                    let newKeyword = Keywords()
                    newKeyword.date = Date()
                    newKeyword.name = keyword.removeDash()
                    newKeyword.rank = listLine
                    newKeyword.requestedURL = link
                    
                    self.selectedDomain?.keywords.append(newKeyword)
                    self.loadData()
                })
            } catch {
                print("Error newKeyword add: \(error)")
            }
        }
    }
    
    func getLinks(link: String) {
        
    }
    
    
    func didFailWithError(error: Error) {
        
    }
}

