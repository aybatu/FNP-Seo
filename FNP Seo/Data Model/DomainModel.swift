//
//  DomainModel.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import Foundation

struct DomainModel {
    func currentDate(date: Date) -> String  {
        let date = date
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let year = String(calendar.component(.year, from: date))
        
        let currentDate = "\(day).\(month).\(year)"
        
        return currentDate
    }
}
