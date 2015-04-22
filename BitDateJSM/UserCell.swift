//
//  UserCell.swift
//  
//
//  Created by Jared Mermey on 4/21/15.
//
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews(){
        
        super.layoutSubviews()
        //rounds corners of image view
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        //image doesnt exceed size of image view
        avatarImageView.layer.masksToBounds = true
        
    }

}
