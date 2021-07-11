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
    lazy var keywordModel = KeywordModel()
    lazy var seo = SEO()

    var keyword: Results<Keywords>?
    var statistics: Results<StatisticResult>?
    
    var selectedDomain: WebSites? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        seo.delegate = self
        navigationItem.title = selectedDomain?.domainName
        navigationItem.backButtonTitle = "Keywords"
        alexaResultLabel.text = selectedDomain?.alexaResult ?? "No Result."
    }
    
    //MARK: - Table View Pull Refresh
    
    @objc func refresh(_ sender: AnyObject) {
        var keywordArray = [String]()
       
        keywordModel.keywordNames.forEach { keyword in
            guard let keySafe = keyword else {return}
            keywordArray.append(keySafe)
        }

        keywordModel.keywordNames = [String]()
        keywordModel.keywordRanks = [Double]()
        keywordModel.averageRank = 0
        keywordModel.keywordCount = 0
        
        keywordArray.forEach { keyword in
            self.seo.fetchSEO(keyword: keyword, requestURL: self.selectedDomain!.domainName)
        }
     
        let deadLine = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: - Add Button Pressed
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Keyword", message: "Please add your keyword to achive seo rank result.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let textSafe = text.text {
                let textPrefix = textSafe.removeWhitespace()
                if self.keywordModel.keywordNames.count > 0 {
                    if self.keywordModel.keywordNames.contains(textSafe) {
                        let alert = UIAlertController(title: "Failed", message: "The keyword \(textSafe) already entered once.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
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
        let statisticsCell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.statisticsCell, for: indexPath)
        var result = UITableViewCell()
        
        if indexPath.section == 0 && indexPath.row == 0 {
            statisticsCell.detailTextLabel?.text = keywordModel.averageRankString
            statisticsCell.textLabel?.text = "Average Ranking"
            result = statisticsCell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            statisticsCell.detailTextLabel?.text = keywordModel.keywordCountString
            statisticsCell.textLabel?.text = "Total Keywords"
            result = statisticsCell
        }
        
        if 0 < keywordModel.keywordRanks!.count  && 0 < keywordModel.keywordNames.count && indexPath.section == 1 {
            keywordCell.detailTextLabel?.text = String((selectedDomain?.keywords[indexPath.row].rank)!)
            keywordCell.textLabel?.text = selectedDomain?.keywords[indexPath.row].name
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
            destinationVC.selectedKeyword = selectedDomain?.keywords[indexPath.row].statistics.sorted(byKeyPath: "date", ascending: true)
           
        }
    }
   
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { action, view, escape in
            self.deleteData(indexPath: indexPath)
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red
        
        if indexPath.section == 1 {
            return UISwipeActionsConfiguration(actions: [action])
        } else if indexPath.section == 0 {
            return nil
        } else {
            return nil
        }
    }
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "rank")
        statisticCalculate(keyword: keyword)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func statisticCalculate(keyword: Results<Keywords>?) {
        keywordModel.averageOfRanks(resultKeyword: keyword)
        keywordModel.saveKeywords(from: keyword)
    }
    
    func deleteData(indexPath: IndexPath?) {
        do {
            try realm.write {
                realm.delete(selectedDomain!.keywords[indexPath!.row].statistics)
                realm.delete(selectedDomain!.keywords[indexPath!.row])
            }
        } catch {
            print("Error delete keyword: \(error)")
        }
        guard let _ = keywordModel.keywordRanks?.removeLast() else {return}
        guard let _ = keywordModel.keywordNames.removeLast() else {return}
        
        loadData()
    }
}

//MARK: - SEO Delegate

extension KeywordViewController: SEODelegate {
    
    func seoModel(link: String, url: String, listLine: Int, keyword: String) {
        DispatchQueue.main.async {
            
            do {
                try self.realm.write {
                    let newKeyword = Keywords()
                    let newStatistic = StatisticResult()
                    let date = Date().timeIntervalSince1970
                    var dateComponent = DateComponents()
                    dateComponent.day = 1
                    
                    newStatistic.date = Date().timeIntervalSince1970
                    newStatistic.name = keyword.removeDash()
                    newStatistic.rank = listLine
                    newStatistic.requestedURL = link
                    
                    guard let newKey = self.selectedDomain?.keywords.filter("name = %@", keyword).last else {
                        newKeyword.name = keyword.removeDash()
                        newKeyword.rank = listLine
                        self.selectedDomain?.keywords.append(newKeyword)
                        newKeyword.statistics.append(newStatistic)
                        self.loadData()
                        return
                    }
                    guard let oldStatistic = newKey.statistics.last?.date else {return}
                    let oldStatisticDate = Date(timeIntervalSince1970: oldStatistic)
                    guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: oldStatisticDate)?.timeIntervalSince1970 else {return}

                    newKey.rank = listLine
                    newKey.name = keyword
                    if date >= futureDate {
                        newKey.statistics.append(newStatistic)
                    }
                    
                    self.loadData()
                    return
                }
            } catch {
                print("Error newKeyword add: \(error)")
            }
        }
    }
    
    func getLinks(link: String) {
        //used for link list view controller
    }
    
    
    func didFailWithError(error: Error) {
        
    }
}

