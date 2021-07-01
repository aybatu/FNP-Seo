//
//  Formatters.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 1.07.2021.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "-")
    }
    
    func removeDash() -> String {
        return self.replace(string: "-", replacement: " ")
    }
}
