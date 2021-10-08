//
//  Constant.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import Foundation

struct K {
    static let appName = "SEO LIFE"
    
    struct DomainTable  {
        static let domainCell = "DomainCell"
    }
    
    struct Keyword {
        static let statisticsCell = "StatisticsCell"
        static let keywordCell = "KeywordCell"
        
    }
    
    struct Links {
        static let linkCellNib = "LinkListCell"
        static let linkCell = "LinkListCell"
        static let chartCellNib = "ChartsCell"
        static let chartsCell = "ChartsCell"
    }
    
    struct Segue {
        static let domianToKeyword = "DomainToKeyword"
        static let keywordToLinks = "KeywordToLinks"
        static let linkToWeb = "LinkToWebView"
        static let linkToChart = "LinkToChart"
        static let domainToSettings = "DomainToSettings"
    }
}
