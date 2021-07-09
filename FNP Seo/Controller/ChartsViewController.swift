//
//  ChartsViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 5.07.2021.
//

#if canImport(UIKit)
    import UIKit
#endif
import RealmSwift
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
        
        setView()
        lineChartData()
    }
    
    
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setView() {
 
        let xaxis = lineChartView.xAxis
        xaxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xaxis.labelTextColor = .label
        xaxis.axisMaxLabels = 7
        xaxis.setLabelCount(selectedKeyword!.count , force: true)
        xaxis.labelPosition = .top
        xaxis.drawGridLinesEnabled = false
        xaxis.axisLineColor = .label
        xaxis.axisLineWidth = 1
        xaxis.valueFormatter = DateValueFormatter()
        

        lineChartView.animate(xAxisDuration: 2)
        lineChartView.rightAxis.enabled = false
               
        lineChartView.backgroundColor = .white
        
        lineChartView.setScaleEnabled(true)
        lineChartView.setViewPortOffsets(left: 45, top: 50, right: 40, bottom: 0)
    }

   
    
    func lineChartData() {
        guard let realmData = selectedKeyword else {return}
        var chartDataEntryRaw = [ChartDataEntry]()
        
        realmData.forEach { statics in
            chartDataEntryRaw.append(ChartDataEntry(x: Double(statics.date), y: Double(statics.rank)))
        }
       
        
        let chartDataEntry = chartDataEntryRaw

        let dataSet = LineChartDataSet(entries: chartDataEntry, label: "Rank")
        let data = LineChartData(dataSet: dataSet)
        
//
  
        dataSet.mode = .horizontalBezier
        dataSet.lineWidth = 1
        dataSet.setColor(.label)
        dataSet.setColor(.systemTeal)
        dataSet.fillColor = .systemTeal
        dataSet.fillAlpha = 0.1
        
        dataSet.axisDependency = .left

        dataSet.highlightEnabled = true
        dataSet.highlightColor = .systemRed
        dataSet.highlightLineWidth = 1

        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = true
      
        lineChartView.data = data
        
        lineChartView.setVisibleXRange(minXRange: 50000, maxXRange: 600000)
    }
}

