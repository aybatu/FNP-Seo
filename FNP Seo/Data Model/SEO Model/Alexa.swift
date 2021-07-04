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
            guard let data = data, err == nil else {
                print("Error dataTask alexa: \(err!)")
                return
            }
           
            let decoder = XMLDecoder()
            decoder.shouldProcessNamespaces = true
            do {
                let data = try decoder.decode(Alexa.self, from: data)
                let alexa = data.SD[1].POPULARITY[0].TEXT
                self.delegate?.alexaResult(alexaResult: alexa, domainURL: urlDomain)
            } catch {
                print(error)
            }
        }.resume()
    }
}
