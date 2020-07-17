//
//  Cell.swift
//  Feedback
//
//  Created by Данила on 07.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit
// Прототип для основной ячейки
class Cell: UITableViewCell {

    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
