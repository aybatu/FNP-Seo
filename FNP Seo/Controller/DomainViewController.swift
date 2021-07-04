//
//  DomainViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 22.06.2021.
//

import UIKit
import RealmSwift

class DomainViewController: UITableViewController {
    
    let realm = try! Realm()
    var domain: Results<WebSites>?
    let alexa = Decoder()
    var alexaScore = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        alexa.delegate = self
        loadData()
    }
    
    //MARK: -  Add pressed
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        
        let alert = UIAlertController(title: "New Domain", message: "Please type domain name you would like to add.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if text.text != "" {
                if let textSafe = text.text {
                    self.alexa.fetchAlexa(for: textSafe)
                    
                }
            }
        }
        
        alert.addAction(action)
        alert.addTextField { textField in
            text = textField
            text.placeholder = "Domain name..."
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domain?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.DomainTable.domainCell, for: indexPath)
        
        cell.textLabel?.text = domain?[indexPath.row].domainName ?? "No domain added yet."
        return cell
    }
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        domain = realm.objects(WebSites.self).sorted(byKeyPath: "date", ascending: true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
    
    func saveData(website domain: WebSites) {
        do {
            try realm.write({
                realm.add(domain)
            })
        } catch {
            print("Error saving website domain: \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.domianToKeyword, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! KeywordViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedDomain = domain?[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { action, view, escape in
            do {
                try self.realm.write {
                    self.domain![indexPath.row].keywords.forEach({ key in
                        self.realm.delete(key.statistics)
                    })
                    self.realm.delete(self.domain![indexPath.row].keywords)
                    self.realm.delete(self.domain![indexPath.row])
                }
            } catch {
                print("Error deleting domain name: \(error)")
            }
            tableView.reloadData()
        }
        
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red
        
        let swipe = UISwipeActionsConfiguration(actions: [action])
        return swipe
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let date = domain?[indexPath.row].date
        let dateString = date?.getFormattedDate(format: "dd.MM.yyyy")
        
        let action = UIContextualAction(style: .normal, title: dateString) { action, view, escape in
            
        }
        action.backgroundColor = .systemTeal
        
        let swipe = UISwipeActionsConfiguration(actions: [action])
        
        return swipe
    }
}

extension DomainViewController: AlexaDelegate {
    
    func alexaResult(alexaResult: String, domainURL: String) {
        let newDomain = WebSites()

        newDomain.domainName = domainURL
        newDomain.date = Date()
        newDomain.alexaResult = alexaResult
        alexaScore = alexaResult
        DispatchQueue.main.async {
            self.saveData(website: newDomain)
        }
    }
    
    
}
