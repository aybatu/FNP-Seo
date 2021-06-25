//
//  Statistic.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 26.06.2021.
//

import Foundation
import RealmSwift

class Statistic: Object {
    var parentKeywords = LinkingObjects(fromType: Keywords.self, property: "statistic")
}
