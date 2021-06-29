//
//  SectionModel.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 27.06.2021.
//

import Foundation
import RealmSwift

struct KeywordModel {
    var keywordRanks = [Double]()
    var averageRank: Double? = 0.0
    var keywordCount: Int? = 0
    var keywordNames = [String]()
    
    var keywordCountString: String? {
        return String(keywordCount!)
    }
    var averageRankString: String? {
        return String(format: "%.01f", averageRank!)
    }
    
    mutating func averageOfRanks(resultKeyword: Results<Keywords>?) {
        var n = 0
        var raw = [Double]()
       
        while n < resultKeyword!.count {
            raw.append(Double(resultKeyword![n].rank))
            keywordRanks = raw
            n += 1
        }
        
        let rankSum = keywordRanks.reduce(0, +)
        averageRank = rankSum / Double(keywordRanks.count)
    }
    
    mutating func saveKeywords(from results: Results<Keywords>?) {
        if results!.count > 0 {
            var n = 0
            var raw = [String]()
            while n < results!.count {
                raw.append(results![n].name)
                n += 1
            }
            keywordNames = raw
        }
    }
}
