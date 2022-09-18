//
//  TableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // starImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
