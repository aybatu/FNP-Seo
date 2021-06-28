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
   
    
    var seo = SEO()
    let realm = try! Realm()
    var sectionData = [SectionData]()
    var sectionModel = SectionModel()
   
    var keyword: Results<Keywords>?
    var selectedDomain: WebSites? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seo.delegate = self
        alexaResultLabel.text = selectedDomain?.alexaResult
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "date", ascending: true)
        sectionData.append(SectionData(sectionTitle: "Statistics", sectionResults: keyword))
        sectionData.append(SectionData(sectionTitle: "Keywords", sectionResults: keyword))
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
        return sectionData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return sectionData[section].sectionResults!.count
        }      
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section].sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var result = UITableViewCell()
        let keywordCell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.keywordCell, for: indexPath)
        let aveRankCell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.averageRankingCell)
        let totalKeywordsCount = tableView.dequeueReusableCell(withIdentifier: K.Keyword.totalKeywordsCell)
      
        if indexPath.section == 0 && indexPath.row < 3{
            if indexPath.row == 0 {
                aveRankCell?.textLabel?.text = "Average Ranking"
                aveRankCell?.detailTextLabel!.text = sectionModel.averageRankString
                result = aveRankCell!
            } else if indexPath.row == 1 && indexPath.row < 3 {
                totalKeywordsCount?.textLabel?.text = "Total Keywords"
                totalKeywordsCount?.detailTextLabel!.text = sectionModel.keywordCountString
                result = totalKeywordsCount!
            }
        } else if indexPath.section == 1 {
            keywordCell.textLabel?.text = sectionData[indexPath.section].sectionResults?[indexPath.row].name ?? "No keyword add yet."
            keywordCell.detailTextLabel?.text = String(sectionData[indexPath.section].sectionResults?[indexPath.row].rank ?? 0)
            result = keywordCell
        }
        return result
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            let action = UIContextualAction(style: .normal, title: nil) { action, view, escape in
                
                do {
                    try self.realm.write({
                        self.realm.delete(self.keyword![indexPath.row])
                    })
                } catch {
                    print("Error delete keyword: \(error)")
                }
                self.sectionModel.keywordRanks.removeLast()
                self.loadData()
            }
            
            action.image = UIImage(systemName: "trash.fill")
            action.backgroundColor = .red

            let swipe = UISwipeActionsConfiguration(actions: [action])
            return swipe
        } else {
            return nil
        }
    }
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "date", ascending: true)
        statisticCalculate(keyword: keyword)
        
        tableView.reloadData()
    }
    
    func statisticCalculate(keyword: Results<Keywords>?) {
        sectionModel.keywordCount = keyword?.count
        sectionModel.averageOfRanks(resultKeyword: keyword)
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
}

//MARK: - SEO Delegate

extension KeywordViewController: SEODelegate {
    
    func SEOModel(link: String, url: String, listLine: Int, keyword: String) {
        
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
