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
        static let totalKeywordsCell = "TotalKeywordsCell"
        static let averageRankingCell = "AverageRankingCell"
        static let keywordCell = "KeywordCell"
        
    }
    
    struct Links {
        static let linkCell = "LinkListCell"
        static let cellNib = "LinkListCell"
    }
    
    struct Segue {
        static let domianToKeyword = "DomainToKeyword"
        static let keywordToLinks = "KeywordToLinks"
        static let linkToWeb = "LinkToWebView"
    }
}
