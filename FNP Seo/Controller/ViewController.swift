//
//  ViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 21.06.2021.
//

import UIKit

class ViewController: UIViewController, SEODelegate {
    

    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var requestUrlLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var seo = SEO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seo.delegate = self
        keywordTextField.placeholder = "Type a keyword..."
        urlTextField.placeholder = "Enter a domain name..."
        requestUrlLabel.text = ""
        keywordLabel.text = ""
        resultLabel.text = ""
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        seo.delegate = self
        keywordTextField.placeholder = "Type a keyword..."
        urlTextField.placeholder = "Enter a domain name..."
        requestUrlLabel.text = ""
        keywordLabel.text = ""
        resultLabel.text = ""
        if let keyword = keywordTextField.text, let url = urlTextField.text {
            seo.fetchSEO(keyword: keyword, requestURL: url)
        }
    }
    
    func SEOModel(link: String, url: String, listLine: Int) {
        DispatchQueue.main.async {
            self.resultLabel.text = String(listLine)
            self.keywordLabel.text = self.keywordTextField.text
            self.requestUrlLabel.text = link
        }
    
    }
    
}

