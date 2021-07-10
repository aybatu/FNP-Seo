//
//  ChartsViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 5.07.2021.
//


import UIKit
import RealmSwift
import RealModule
import Charts

class ChartsViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    let realm = try! Realm()
    var selectedKeyword: Results<StatisticResult>?
    override var shouldAutorotate: Bool {
        if UIDevice.current.orientation.isPortrait == true {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
       
        lineChartData()
        setView()
    }
    
    
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setView() {
        lineChartView.leftAxis.enabled = true
        let limitLine = ChartLimitLine(limit: 10.0, label: "RANK: 10")
        limitLine.enabled = true
        limitLine.lineColor = .systemRed
        limitLine.lineWidth = 2
        limitLine.valueTextColor = .systemRed
        limitLine.drawLabelEnabled = true
        lineChartView.leftAxis.addLimitLine(limitLine)
        
        let xaxis = lineChartView.xAxis
        xaxis.valueFormatter = DateValueFormatter()
        xaxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xaxis.labelTextColor = .label
        if selectedKeyword!.count < 8 {
            xaxis.setLabelCount(selectedKeyword!.count , force: true)
        } else {
            xaxis.axisMaxLabels = 7
        }
        xaxis.labelPosition = .bottom
        xaxis.drawGridLinesEnabled = false
        xaxis.axisLineColor = .label
        xaxis.axisLineWidth = 1
        xaxis.avoidFirstLastClippingEnabled = true
        lineChartView.setVisibleXRange(minXRange: 0, maxXRange: 7)

        lineChartView.animate(xAxisDuration: 2)
        lineChartView.rightAxis.enabled = false
        
        lineChartView.setScaleEnabled(true)
        lineChartView.setViewPortOffsets(left: 20, top: 20, right: 30, bottom: 35)
    }

   
    
    func lineChartData() {
        guard let realmData = selectedKeyword else {return}
        var chartDataEntryRaw = [ChartDataEntry]()
        
        realmData.forEach { statics in
            let day = (statics.date - Date().timeIntervalSince1970) / (3600 * 24)
            chartDataEntryRaw.append(ChartDataEntry(x: floor(day), y: Double(statics.rank)))
        }
        
        let chartDataEntry = chartDataEntryRaw

        let dataSet = LineChartDataSet(entries: chartDataEntry, label: "Rank")
        let data = LineChartData(dataSet: dataSet)
 
        dataSet.mode = .horizontalBezier
        dataSet.lineWidth = 1
        dataSet.setColor(.label)
        dataSet.setColor(.systemTeal)
        dataSet.fillColor = .systemTeal
        dataSet.fillAlpha = 0.1
       
        dataSet.highlightEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = true
        
        
        
        
        
      
        lineChartView.data = data
       
    }
}

