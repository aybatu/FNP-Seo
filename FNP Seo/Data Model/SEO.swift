//
//  SEO.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 21.06.2021.
//

import Foundation
protocol SEODelegate {
    func SEOModel(link: String, url: String, listLine: Int)
    func didFailWithError(error: Error)
}

struct SEO {
    var delegate: SEODelegate?
    let apiKey = "AIzaSyBn1MCv4pIKHP3wOkNDiplOsc5wmc0L2aA"
    let searchEngine = "34c9189327a3a48cc"
    let lang = "lang_tr"
    let hl = "tr"
    let location = "tr"
    
   //&lr=\(lang)
    
    func fetchSEO(keyword: String, requestURL: String, _ start: Int?) {
        let start = start
        let url = "https://www.googleapis.com/customsearch/v1?q=\(keyword)&gl=\(location)&start=\(start ?? 1)&key=\(apiKey)&cx=\(searchEngine)"
        
        prepareData(url: url, keyword: keyword, requestURL: requestURL, start: start ?? 1)
    }

    func prepareData(url: String, keyword: String, requestURL: String, start: Int) {
        if let urlString = URL(string: url) {
            print(urlString)
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: urlString) { data, response, error in
                if let e = error {
                    delegate?.didFailWithError(error: e)
                } else {
                    if let dataSafe = data {
                        if let seoData = parseJSON(data: dataSafe) {
                            checkForLinkorNextPage(seoData: seoData, url: url, requestURL: requestURL, keyword: keyword, start: start, listCounter: nil)
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func checkForLinkorNextPage(seoData: SEODataBrain, url: String, requestURL: String, keyword: String, start: Int, listCounter: Int?) {
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
                
                fetchSEO(keyword: keyword, requestURL: requestURL, start)
            }
            print(keyword, start, requestURL, listLine)
        }
    }
    
    func parseJSON(data: Data) -> SEODataBrain? {
        let decoder = JSONDecoder()
        
        do {
            let seoData = try decoder.decode(SEODataBrain.self, from: data)
            return seoData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
