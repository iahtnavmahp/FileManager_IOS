//
//  DetailTableViewCell.swift
//  FileManager_IOS
//
//  Created by Pham Van Thai on 13/04/2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
