//
//  KeywordViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 23.06.2021.
//

import UIKit

class KeywordViewController: UITableViewController {
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    var domain: DomainDataModel? {
        didSet{
            loadData()
        }
    }
    
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("FnpSeo.plist")
    
    var keywordArray = [KeywordDataModel]()
    var seo = SEO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seo.delegate = self
        domainLabel.text = ""
        keywordLabel.text = ""
        rankLabel.text = ""
        loadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Keyword", message: "Please specify and add your keyword to achive seo rank.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let textSafe = text.text {
                let textPrefix = textSafe.removeWhitespace()
                
                self.seo.fetchSEO(keyword: textPrefix, requestURL: (self.domain?.domainTitle)!)
            }
        }
        
        alert.addAction(action)
        alert.addTextField { textfield in
            text = textfield
            textfield.placeholder = "Type a keyword..."
        }
        
        present(alert, animated: true, completion: nil)
      
    }
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Keyword.keywordCell, for: indexPath)
        
        cell.textLabel?.text = keywordArray[indexPath.row].keywordTitle
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        domainLabel.text = keywordArray[indexPath.row].domainTitle
        keywordLabel.text = keywordArray[indexPath.row].keywordTitle
        rankLabel.text = keywordArray[indexPath.row].listedLine
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { action, view, escape in
            
            self.keywordArray.remove(at: indexPath.row)
            self.keywordLabel.text = ""
            self.domainLabel.text = ""
            self.rankLabel.text = ""
            self.saveData()
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .red
        
        let swipe = UISwipeActionsConfiguration(actions: [action])
        
        return swipe
    }
    
    //MARK: - Data Manupulation Methods
    
    func loadData() {
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataPath!) {
            do {
                keywordArray = try decoder.decode([KeywordDataModel].self, from: data)
                
            } catch {
                didFailWithError(error: error)
            }
        }
        tableView.reloadData()
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.keywordArray)
            try data.write(to: self.dataPath!)
        } catch {
            didFailWithError(error: error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
}

//MARK: - SEO Delegate

extension KeywordViewController: SEODelegate {
    
    func SEOModel(link: String, url: String, listLine: Int, keyword: String) {
        DispatchQueue.main.async {
            self.domainLabel.text = link
            self.keywordLabel.text = keyword.removeDash()
            self.rankLabel.text = String(listLine)
        }
        
        var keywordDataModel = KeywordDataModel()
        
        keywordDataModel.domainTitle = link
        keywordDataModel.keywordTitle = keyword.removeDash()
        keywordDataModel.listedLine = String(listLine)
        
        self.keywordArray.append(keywordDataModel)
        self.saveData()
        

        print(keyword, link, listLine)
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "-")
    }
    
    func removeDash() -> String {
        return self.replace(string: "-", replacement: " ")
    }
}
