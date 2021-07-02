//
//  Keywords.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 26.06.2021.
//

import Foundation
import RealmSwift

class Keywords: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var rank: Int = 0
    
    let statistics = List<StatisticResult>()
}
