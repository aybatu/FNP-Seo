//
//  KeywordLinksViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 28.06.2021.
//

import UIKit
import RealmSwift

class KeywordLinksViewController: UITableViewController {
    
    var webSites: Results<WebSites>?
    
    var selectedKeyword: Keywords? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Links.linkCell, for: indexPath)
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
//MARK: - Data Manupulation Methods
    func loadData() {
        
    }
}
