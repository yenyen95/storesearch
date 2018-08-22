//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Aurélien Schneberger on 22/08/2018.
//  Copyright © 2018 Aurélien Schneberger. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var atworkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
