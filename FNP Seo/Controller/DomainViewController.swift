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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: -  Add pressed

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
    
        let alert = UIAlertController(title: "New Domain", message: "Please type domain name you would like to add.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if text.text != "" {
                if let textSafe = text.text {
                    let newDomain = WebSites()
                    newDomain.domainName = textSafe
                    newDomain.date = Date()
                    self.saveData(website: newDomain)
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
        
        tableView.reloadData()
    }
    
    func saveData(website domain: WebSites) {
        do {
            try realm.write({
                realm.add(domain)
            })
        } catch {
            print("Error saving website domain: \(error)")
        }
        
        tableView.reloadData()
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
            if let domain = self.realm.objects(WebSites.self).first {
                let keywords = self.realm.objects(Keywords.self).filter("ANY parentDomain == %@", domain)
                try! self.realm.write {
                    self.realm.delete(keywords)
                }
            }
            
            do {
                try self.realm.write {
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

//MARK: - Date Formatter

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
