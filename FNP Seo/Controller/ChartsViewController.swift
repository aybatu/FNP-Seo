//
//  ChartsViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 5.07.2021.
//

import UIKit
import RealmSwift
import Charts

class ChartsViewController: UIViewController, ChartViewDelegate {

   
    let realm = try! Realm()
    
    let lineChartView: LineChartView = {
        let view = LineChartView()
        view.doubleTapToZoomEnabled = false
        view.extraBottomOffset = 50
        view.xAxis.labelPosition = .bottom
        view.rightAxis.labelCount = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        view.addSubview(lineChartView)
       
        lineChartView.frame = CGRect(x: 20, y: 25, width: self.view.frame.size.width - 40, height: self.view.frame.size.height - 50)
        lineChartData()

       
        
    }
    
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
