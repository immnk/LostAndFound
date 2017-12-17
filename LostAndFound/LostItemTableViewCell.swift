//
//  LostItemTableViewCell.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/17/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit

class LostItemTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
