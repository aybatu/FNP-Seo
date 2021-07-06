//
//  LinkToListViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 6.07.2021.
//

import UIKit
import RealmSwift
import Charts

class LinkListViewController: UIViewController, SEODelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var seo = SEO()
    var keywordRaw: String?
    var linkArray = [String]()
    var selectedKeyword: Results<StatisticResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Results For: \(keywordRaw!)"
        navigationItem.backButtonTitle = "Back"
        
        seo.delegate = self
        seo.fetchSEO(keyword: keywordRaw!, requestURL: nil, start: 1)
        
        tableView.register(UINib(nibName: K.Links.linkCellNib, bundle: nil), forCellReuseIdentifier: K.Links.linkCell)
        
        lineChartView.delegate = self
        lineChartView.frame = CGRect(x: 0, y: 0, width: lineChartView.frame.size.width, height: lineChartView.frame.size.height)
        lineChartData()
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
    
    func seoModelUpdate(link: String, url: String, listLine: Int, keyword: String) {
//
    }
    
    func didFailWithError(error: Error) {
//
    }
}
    //MARK: - Line Chart

extension LinkListViewController: ChartViewDelegate {
    func lineChartData() {
        let set = LineChartDataSet(entries: [
        ChartDataEntry(x: 1, y: 1),
            ChartDataEntry(x: 2, y: 2),
            ChartDataEntry(x: 3, y: 3),
            ChartDataEntry(x: 4, y: 4),
            ChartDataEntry(x: 5, y: 5),
            ChartDataEntry(x: 6, y: 7),
            ChartDataEntry(x: 7, y: 7),
            ChartDataEntry(x: 8, y: 8)
        ])
        set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
    }

}

//MARK: - Table View Data Source Methods
extension LinkListViewController: UITableViewDataSource {
    
    func tableView(numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Links.linkCell, for: indexPath) as! LinkListCell
 
        cell.rankLabel.text = String(indexPath.row + 1)
        cell.urlLabel.text = linkArray[indexPath.row]

        return cell
    }

}


//MARK: - Table View Delegate Methods

extension LinkListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Web Sites Results For The Keyword"
    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.linkToWeb, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.linkToWeb {
            let destinationVC = segue.destination as! WebViewController
                
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.url = linkArray[indexPath.row]
            }
        }
    }

}
