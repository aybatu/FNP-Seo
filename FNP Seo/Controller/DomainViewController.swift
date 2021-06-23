//
//  DomainViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 22.06.2021.
//

import UIKit

class DomainViewController: UITableViewController {
    
    var domainArray = [DomainDataModel]()
    var domainSeo = DomainModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let date = Date()
        let time = date.timeIntervalSince1970
        let recentDate = domainSeo.currentDate(date: date)
        
        let alert = UIAlertController(title: "New Domain", message: "Please type domain name you would like to add.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            self.domainArray.append(DomainDataModel(domainTitle: text.text!, dateString: recentDate, timeSince: time))
            self.reloadData()
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
        return domainArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.DomainTable.domainCell, for: indexPath)
        
        cell.textLabel?.text = domainArray[indexPath.row].domainTitle
        return cell
    }
    
    //MARK: - Data Manupulation Methods
    
    func reloadData() {
        tableView.reloadData()
    }
    
    //MARK: - Table View Delegate Methods
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.domianToKeyword, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! KeywordViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.domain = domainArray[indexPath.row]
        }
       
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { action, view, escape in
            self.domainArray.remove(at: indexPath.row)
            self.reloadData()
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red
        
        let swipe = UISwipeActionsConfiguration(actions: [action])
        
        return swipe
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = domainArray[indexPath.row].dateString
        
        let action = UIContextualAction(style: .normal, title: title) { action, view, escape in
            
        }
        action.backgroundColor = .systemTeal
        
        let swipe = UISwipeActionsConfiguration(actions: [action])
        
        return swipe
    }
    

}
