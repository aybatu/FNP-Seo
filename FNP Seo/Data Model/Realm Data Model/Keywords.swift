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
    @objc dynamic var date: Date = Date()
    @objc dynamic var rank: String = ""
    @objc dynamic var alexa: String = ""
    @objc dynamic var requestedURL: String = ""
    
    var parentDomain = LinkingObjects(fromType: WebSites.self , property: "keywords")
  //  let statistic = List<Statistic>()
    
}
