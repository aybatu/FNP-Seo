//
//  LinkListViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 29.06.2021.
//

import UIKit

class LinkListViewController: UITableViewController, SEODelegate {
   
    
    var seo = SEO()
    var keywordRaw: String?
    var linkArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.Links.cellNib, bundle: nil), forCellReuseIdentifier: K.Links.linkCell)
        seo.delegate = self
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        seo.fetchSEO(keyword: keywordRaw!, requestURL: nil, start: 1)
    }
    
    @objc func refresh() {
        linkArray = [String]()
        seo.fetchSEO(keyword: keywordRaw!, requestURL: nil, start: 1)
        refreshControl?.endRefreshing()
    }
    
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Links.linkCell, for: indexPath) as! LinkListCell
        if linkArray.count > 0 {
            cell.rankLabel.text = String(indexPath.row + 1)
            cell.urlLabel.text = linkArray[indexPath.row]
        }
        return cell
    }
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.linkToWeb, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.url = linkArray[indexPath.row]
        }
    }
    
    
    //MARK: - Seo Delegate Methods
    
    func seoModel(link: String, url: String, listLine: Int, keyword: String) {
     
    }
    
    func getLinks(link: String) {
        DispatchQueue.main.async {
            self.linkArray.append(link)
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
//
    }
}
