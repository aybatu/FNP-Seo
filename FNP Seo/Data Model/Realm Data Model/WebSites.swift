//
//  WebSites.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 26.06.2021.
//

import Foundation
import RealmSwift

class WebSites: Object {
    @objc dynamic var domainName: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var alexaResult: Int = 1
    
    let keywords = List<Keywords>()
}
