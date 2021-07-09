//
//  Alexa.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 3.07.2021.
//

import Foundation
import XMLCoder

protocol AlexaDelegate {
    func alexaResult(alexaResult: String, domainURL: String)
}

class Decoder {
    var delegate: AlexaDelegate?
    
    func fetchAlexa(for urlDomain: String) {
        let urlString = "https://data.alexa.com/data?cli=10&dat=snbamz&url=\(urlDomain)"
        guard let url = URL(string: urlString) else {return}
        let _ = URLSession(configuration: .default).dataTask(with: url) { (data, response, err) in
            if let error = err {
                print("Error dataTask alexa: \(error)")
                return
            }
            if let dataSafe = data {
                let decoder = XMLDecoder()
                decoder.shouldProcessNamespaces = true
                do {
                    
                    
                    let data = try decoder.decode(Alexa.self, from: dataSafe)
                    if let dataCount = data.SD?.count {
                        if dataCount > 1 {
                            let alexa = data.SD?[1].POPULARITY[0].TEXT
                            self.delegate?.alexaResult(alexaResult: alexa!, domainURL: urlDomain)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
