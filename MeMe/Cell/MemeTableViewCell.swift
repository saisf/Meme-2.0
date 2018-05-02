//
//  MemeTableViewCell.swift
//  MeMe
//
//  Created by Sai Leung on 4/25/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var memedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
