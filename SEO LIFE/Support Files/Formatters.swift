//
//  Formatters.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 1.07.2021.
//

import Foundation
import Charts
#if canImport(UIKit)
    import UIKit
#endif


extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.locale = .current
        return dateformat.string(from: self)
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "+")
    }
    
    func removeDash() -> String {
        return self.replace(string: "+", replacement: " ")
    }
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}


public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
    
        dateFormatter.dateFormat = "dd.MM.yy"
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + (value * 3600 * 24))
        return dateFormatter.string(from: date)
    }
}

