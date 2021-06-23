//
//  KeywordViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import UIKit

class KeywordViewController: UITableViewController {
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var listLineLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    
    var domain: DomainDataModel? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
    }
    
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        tableView.reloadData()
    }
}
