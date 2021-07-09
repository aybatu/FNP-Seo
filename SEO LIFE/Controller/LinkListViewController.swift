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
        
        
        lineChartData()
        chartView()
       
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
        return "Website Results For The Keyword"
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
        } else if segue.identifier == K.Segue.linkToChart {
            let destinationVC = segue.destination as! ChartsViewController
            destinationVC.selectedKeyword = selectedKeyword
        }
    }

}

//MARK: - Line Chart

extension LinkListViewController: ChartViewDelegate {
    
    func chartView() {
        lineChartView.frame = CGRect(x: 0, y: 0, width: lineChartView.frame.size.width, height: lineChartView.frame.size.height)
        lineChartView.rightAxis.enabled = false
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .top
        if selectedKeyword!.count < 7 {
            xAxis.setLabelCount(selectedKeyword!.count, force: true)
        } else {
            lineChartView.xAxis.axisMaxLabels = 7
        }
        lineChartView.setVisibleXRange(minXRange: 50000, maxXRange: 500000)
    }
    
func lineChartData() {
    let listFormatter = DateValueFormatter()
    guard let realmData = selectedKeyword else {return}
    var chartDataEntryRaw = [ChartDataEntry]()

    realmData.forEach { statics in
        chartDataEntryRaw.append(ChartDataEntry(x: statics.date, y: Double(statics.rank)))
    }

    let chartDataEntry = chartDataEntryRaw

    let dataSet = LineChartDataSet(entries: chartDataEntry, label: "Rank")
    let data = LineChartData(dataSet: dataSet)
    lineChartView.xAxis.valueFormatter = listFormatter
    dataSet.colors = ChartColorTemplates.material()
    lineChartView.data = data
}

}
