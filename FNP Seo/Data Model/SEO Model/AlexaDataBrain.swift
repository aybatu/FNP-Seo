//
//  AlexaDataBrain.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 3.07.2021.
//

import Foundation

struct Alexa: Codable, Equatable {
    let SD: [SD]
    
    struct SD: Codable, Equatable {
        let POPULARITY: [POPULARITY]
    }
    struct POPULARITY: Codable, Equatable {
        let URL: String
        let TEXT: String
        let SOURCE: String
    }
}
