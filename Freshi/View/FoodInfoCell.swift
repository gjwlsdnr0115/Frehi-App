//
//  FoodInfoCell.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/05.
//

import UIKit

class FoodInfoCell: UITableViewCell {

    
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodCountLabel: UILabel!
    @IBOutlet weak var foodPurchaseDateLabel: UILabel!
    @IBOutlet weak var foodExpireDayLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foodImageView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
