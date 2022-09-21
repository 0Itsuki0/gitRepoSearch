//
//  TableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundColorView: UIView!
    
    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var repoUpdateDateLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundColorView.backgroundColor = UIColor.clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        cellBackgroundColorView.layer.insertSublayer(gradientLayer, at: 0)
       
        starImage.accessibilityIdentifier = "starImage"
        repoLanguageLabel.accessibilityIdentifier = "repoLanguageLabel"
        repoUpdateDateLabel.accessibilityIdentifier = "repoUpdateDateLabel"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
