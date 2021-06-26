//
//  KeywordViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import UIKit
import RealmSwift

class KeywordViewController: UITableViewController {
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var seo = SEO()
    let realm = try! Realm()
    
    var keyword: Results<Keywords>?
    var selectedDomain: WebSites? {
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seo.delegate = self
        domainLabel.text = ""
        keywordLabel.text = ""
        rankLabel.text = ""
        loadData()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Keyword", message: "Please specify and add your keyword to achive seo rank.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let textSafe = text.text {
                let textPrefix = textSafe.removeWhitespace()
                self.seo.fetchSEO(keyword: textPrefix, requestURL: self.selectedDomain!.domainName, start: 1)
                
                self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyword?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.keywordCell, for: indexPath)
        
        cell.textLabel?.text = keyword?[indexPath.row].name ?? "No keyword add yet."
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        domainLabel.text = keyword?[indexPath.row].requestedURL
        keywordLabel.text = keyword?[indexPath.row].name
        rankLabel.text = keyword?[indexPath.row].rank
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { action, view, escape in
            self.keywordLabel.text = ""
            self.domainLabel.text = ""
            self.rankLabel.text = ""
            
            do {
                try self.realm.write({
                    self.realm.delete(self.keyword![indexPath.row])
                })
            } catch {
                print("Error delete keyword: \(error)")
            }
            
            tableView.reloadData()
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red

        let swipe = UISwipeActionsConfiguration(actions: [action])

        return swipe
    }
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        keyword = selectedDomain?.keywords.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
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
            self.domainLabel.text = link
            self.keywordLabel.text = keyword.removeDash()
            self.rankLabel.text = String(listLine)
        }
       
        DispatchQueue.main.async {
            do {
                try self.realm.write({
                    let newKeyword = Keywords()
                    newKeyword.date = Date()
                    newKeyword.name = keyword.removeDash()
                    newKeyword.rank = String(listLine)
                    newKeyword.requestedURL = link
    //                newKeyword.alexa = will be updated
                    
                    self.selectedDomain?.keywords.append(newKeyword)
                })
            } catch {
                print("Error newKeyword add: \(error)")
            }
            self.tableView.reloadData()
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
