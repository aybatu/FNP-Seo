//
//  SectionModel.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 27.06.2021.
//

import Foundation
import RealmSwift

struct KeywordModel {
    var keywordRanks: [Double]? = [Double]()
    var averageRank: Double? = 0.0
    var keywordCount: Int? = 0
    var keywordNames = [String?]()
    
    var keywordCountString: String? {
        return String(keywordCount!)
    }
    var averageRankString: String? {
        return String(format: "%.01f", averageRank!)
    }
    
    mutating func averageOfRanks(resultKeyword: Results<Keywords>?) {
        guard let results = resultKeyword else {return}
        keywordCount = results.count
        var n = 0
        var raw = [Double]()
            
        while n < results.count {
            raw.append(Double(resultKeyword![n].rank))
            n += 1
        }
        keywordRanks = raw
        
        guard let keyRanks = keywordRanks else {return}
        let rankSum = keyRanks.reduce(0, +)
        averageRank = rankSum / Double(keyRanks.count)
        
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
