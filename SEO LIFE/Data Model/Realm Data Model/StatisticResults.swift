//
//  Results.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 1.07.2021.
//

import Foundation
import RealmSwift

class StatisticResult: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: TimeInterval = Date().timeIntervalSince1970
    @objc dynamic var rank: Int = 0
    @objc dynamic var requestedURL: String = ""
}
