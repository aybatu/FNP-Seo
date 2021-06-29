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
    
    var keyword: Results<Keywords>?
    var seo = SEO()
    var keywordSectionData = [KeywordSectionData]()
    var keywordModel = KeywordModel()
    var selectedDomain: WebSites? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        seo.delegate = self
        alexaResultLabel.text = selectedDomain?.alexaResult
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "date", ascending: true)
        keywordSectionData.append(KeywordSectionData(sectionTitle: "Statistics", sectionResults: keyword))
        keywordSectionData.append(KeywordSectionData(sectionTitle: "Keywords", sectionResults: keyword))
    }

    @objc func refresh(_ sender: AnyObject) {

//        if keywordModel.keywordNames.count == 0 {
//            refreshControl?.endRefreshing()
//        } else {
//
//        let keywords = keywordModel.keywordNames.enumerated()
//        keywords.forEach { keyword in
//            seo.fetchSEO(keyword: keyword.element, requestURL: selectedDomain!.domainName, start: 1)
//        }
//            print("test")
//
//        }
//        do {
//            try realm.write({
//                realm.delete(keyword!)
//            })
//        } catch {
//            print(error)
//        }
       // loadData()
        refreshControl?.endRefreshing()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Keyword", message: "Please specify and add your keyword to achive seo rank.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let textSafe = text.text {
                let textPrefix = textSafe.removeWhitespace()
                self.seo.fetchSEO(keyword: textPrefix, requestURL: self.selectedDomain!.domainName, start: 1)
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
        return keywordSectionData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return keywordSectionData[section].sectionResults!.count
        }      
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keywordSectionData[section].sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var result = UITableViewCell()
        let keywordCell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.keywordCell, for: indexPath)
        let aveRankCell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.averageRankingCell)
        let totalKeywordsCount = tableView.dequeueReusableCell(withIdentifier: K.Keyword.totalKeywordsCell)
      
        if indexPath.section == 0 && indexPath.row < 3{
            if indexPath.row == 0 {
                aveRankCell?.textLabel?.text = "Average Ranking"
                aveRankCell?.detailTextLabel!.text = keywordModel.averageRankString
                result = aveRankCell!
            } else if indexPath.row == 1 && indexPath.row < 3 {
                totalKeywordsCount?.textLabel?.text = "Total Keywords"
                totalKeywordsCount?.detailTextLabel!.text = keywordModel.keywordCountString
                result = totalKeywordsCount!
            }
        } else if indexPath.section == 1 {
            keywordCell.textLabel?.text = keywordModel.keywordNames[indexPath.row]
            keywordCell.detailTextLabel?.text = String(format: "%.0f", keywordModel.keywordRanks[indexPath.row])
            result = keywordCell
        }
        return result
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
                keywordModel.keywordRanks.removeLast()
                keywordModel.keywordNames.removeLast()
                loadData()
            }
        }
    }
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "date", ascending: true)
        statisticCalculate(keyword: keyword)
        keywordModel.saveKeywords(from: keyword)
        tableView.reloadData()
    }
    
    func statisticCalculate(keyword: Results<Keywords>?) {
        keywordModel.keywordCount = keyword?.count
        keywordModel.averageOfRanks(resultKeyword: keyword)
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
                if indexPath != nil {
                    realm.delete(keyword![indexPath!.row])
                } else {
                    self.selectedDomain?.keywords.removeAll()
                }
            }
        } catch {
            print("Error delete keyword: \(error)")
        }
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

//MARK: - String dash and whitespace remove

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "-")
    }
    
    func removeDash() -> String {
        return self.replace(string: "-", replacement: " ")
    }
}
