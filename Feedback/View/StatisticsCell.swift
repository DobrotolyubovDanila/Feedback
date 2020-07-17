//
//  StatisticsCell.swift
//  Feedback
//
//  Created by Данила on 08.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit
// Класс для ячейки отсортированного списка.
class StatisticsCell: UITableViewCell {

    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var regionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
