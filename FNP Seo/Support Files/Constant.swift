//
//  Constant.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import Foundation

struct K {
    struct DomainTable  {
        static let domainCell = "DomainCell"
    }
    
    struct Keyword {
        static let statisticsCell = "StatisticsCell"
        static let keywordCell = "KeywordCell"
        
    }
    
    struct Links {
        static let cellNib = "LinkListCell"
        static let linkCell = "LinkListCell"
    }
    
    struct Segue {
        static let domianToKeyword = "DomainToKeyword"
        static let keywordToLinks = "KeywordToLinks"
        static let linkToWeb = "LinkToWebView"
    }
}
