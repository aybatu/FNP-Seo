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
    
    lazy var seo = SEO()
    var keywordRaw: String?
    lazy var linkArray = [String]()
    var selectedKeyword: Results<StatisticResult>?

    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        seo.delegate = self
        
        navigationItem.title = "Results For: \(keywordRaw!.removeDash())"
        navigationItem.backButtonTitle = "Back"
        
        tableView.register(UINib(nibName: K.Links.linkCellNib, bundle: nil), forCellReuseIdentifier: K.Links.linkCell)
        
        lineChartData()
        chartView()
    }

    override func viewWillAppear(_ animated: Bool) {
        seo.fetchSEO(keyword: keywordRaw!, requestURL: nil, start: 1)
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

//MARK: - Line Chart View

extension LinkListViewController: ChartViewDelegate {
 
    func chartView() {
        let xAxis = lineChartView.xAxis
        xAxis.granularityEnabled = true
        xAxis.granularity = 1.0
        xAxis.labelRotationAngle = 0
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.labelPosition = .bottom
        if selectedKeyword!.count < 5 {
            xAxis.setLabelCount(selectedKeyword!.count, force: true)
        } else {
            xAxis.axisMaxLabels = 4
        }
        xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.setVisibleXRange(minXRange: 1, maxXRange: 5)
        
        let yAxis = lineChartView.leftAxis
        yAxis.granularityEnabled = true
        yAxis.granularity = 1
        if selectedKeyword!.count < 10 {
            yAxis.labelCount = selectedKeyword!.count
        } else {
            yAxis.setLabelCount(10, force: true)
        }
        
        lineChartView.frame = CGRect(x: 0, y: 0, width: lineChartView.frame.size.width, height: lineChartView.frame.size.height)
        lineChartView.rightAxis.enabled = false
        
    }
    //MARK: - Line Chart Data
    func lineChartData() {
        guard let realmData = selectedKeyword?.sorted(byKeyPath: "date", ascending: true) else {return}
        var chartDataEntryRaw = [ChartDataEntry]()
        
        realmData.forEach { statics in
            let day = (statics.date - Date().timeIntervalSince1970) / (3600 * 24)
            chartDataEntryRaw.append(ChartDataEntry(x: round(1 * day / 1), y: Double(statics.rank)))
        }
        
        let dataSet = LineChartDataSet(entries: chartDataEntryRaw, label: "Rank")
        let data = LineChartData(dataSet: dataSet)
        
        dataSet.colors = ChartColorTemplates.material()
        lineChartView.data = data
    }
    
}
