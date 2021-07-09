//
//  File.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 21.06.2021.
//

import Foundation

struct SEODataBrain: Decodable {
    let items: [Link]
}
struct Link: Decodable {
    let link: String?
}

