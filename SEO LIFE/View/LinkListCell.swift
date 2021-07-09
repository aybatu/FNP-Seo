//
//  LinkListCell.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 29.06.2021.
//

import UIKit

class LinkListCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
