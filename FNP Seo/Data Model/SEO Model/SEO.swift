//
//  SEO.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 21.06.2021.
//

import Foundation
protocol SEODelegate {
    func SEOModel(link: String, url: String, listLine: Int, keyword: String)
    func didFailWithError(error: Error)
}

struct SEO {
    var delegate: SEODelegate?
    let apiKey = "AIzaSyBn1MCv4pIKHP3wOkNDiplOsc5wmc0L2aA"
    let searchEngine = "34c9189327a3a48cc"
    let lang = "lang_tr"
    let hl = "tr"
    let location = "tr"

    func fetchSEO(keyword: String, requestURL: String, start: Int? = 1) {
        let start = start
        let urlString = "https://www.googleapis.com/customsearch/v1?q=\(keyword)&lr=\(lang)&gl=\(location)&start=\(start ?? 1)&key=\(apiKey)&cx=\(searchEngine)"
        
        performRequest(with: urlString, for: keyword, request: requestURL, startIndex: start ?? 1)
    }

    func performRequest(with urlString: String, for keyword: String, request requestURL: String, startIndex: Int) {
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            print(urlString)
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    delegate?.didFailWithError(error: e)
                } else {
                    if let dataSafe = data {
                        if let seoData = parseJSON(data: dataSafe) {
                            checkForLinkorNextPage(seoData: seoData, url: urlString, requestURL: requestURL, keyword: keyword, nextPageStartIndex: startIndex)
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func checkForLinkorNextPage(seoData: SEODataBrain, url: String, requestURL: String, keyword: String, nextPageStartIndex: Int) {
        var n = 0
        var startIndexForNextPage = nextPageStartIndex
        
        while n < seoData.items.count {
            if let link = seoData.items[n].link {
                let listLine = startIndexForNextPage + n
                
                if link.contains(requestURL) {
                    delegate?.SEOModel(link: link, url: requestURL, listLine: listLine, keyword: keyword)
                    n = 0
                    return
                } else {
                    n += 1
                }
                
                if n == 10 {
                    startIndexForNextPage += 10
                    fetchSEO(keyword: keyword, requestURL: requestURL, start: startIndexForNextPage)
                }
            }
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
