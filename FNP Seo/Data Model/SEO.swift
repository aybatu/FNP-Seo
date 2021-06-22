//
//  SEO.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 21.06.2021.
//

import Foundation
protocol SEODelegate {
    func SEOModel(link: String, url: String, listLine: Int)
}



struct SEO {
    var delegate: SEODelegate?
    let apiKey = "AIzaSyBn1MCv4pIKHP3wOkNDiplOsc5wmc0L2aA"
    let searchEngine = "34c9189327a3a48cc"
    let lang = "lang_tr"
    let hl = "tr"
    let location = "tr"
    
   //&lr=\(lang)
    
    func fetchSEO(keyword: String, requestURL: String) {
        let start = 1
        let url = "https://www.googleapis.com/customsearch/v1?q=\(keyword)&gl=\(location)&start=\(start)&key=\(apiKey)&cx=\(searchEngine)"
        
        if let urlString = URL(string: url) {
            print(urlString)
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: urlString) { data, response, error in
                if let e = error {
                    print(e)
                } else {
                    if let dataSafe = data {
                        if let seoData = parseJSON(data: dataSafe) {
                            test(seoData: seoData, url: url, requestURL: requestURL, keyword: keyword, start: start, listCounter: nil)
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func test(seoData: SEODataBrain, url: String, requestURL: String, keyword: String, start: Int, listCounter: Int?) {
        var n = 0
        var start = start
        
        while n < seoData.items.count {
            let link = seoData.items[n].link
            let listLine = start + n
            if link.contains(requestURL) {
                delegate?.SEOModel(link: link, url: requestURL, listLine: listLine)
                n = 0
                return
            } else {
                n += 1
            }
            
            if n == 10 {
                start += 10
                
                nextPage(start: start, keyword: keyword, requestURL: requestURL, seoData: seoData, transferListLine: listLine)
            }
            print(keyword, start, requestURL, listLine)
        }
    }
    
    func nextPage(start: Int, keyword: String, requestURL: String, seoData: SEODataBrain, transferListLine: Int?) {
        let url = "https://www.googleapis.com/customsearch/v1?q=\(keyword)&gl=\(location)&start=\(start)&key=\(apiKey)&cx=\(searchEngine)"
        
        if let urlString = URL(string: url) {
            print(urlString)
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: urlString) { data, response, error in
                if let e = error {
                    print(e)
                } else {
                    if let dataSafe = data {
                        if let seoData = parseJSON(data: dataSafe) {
                            
                            test(seoData: seoData, url: url, requestURL: requestURL, keyword: keyword, start: start, listCounter: transferListLine)
                  
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    
    func parseJSON(data: Data) -> SEODataBrain? {
        let decoder = JSONDecoder()
        
        do {
            let seoData = try decoder.decode(SEODataBrain.self, from: data)
            return seoData
        } catch {
            print("Parse Json error: \(error)")
            return nil
        }
    }
    
}
