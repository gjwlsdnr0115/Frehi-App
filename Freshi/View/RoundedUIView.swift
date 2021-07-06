//
//  RoundedUIView.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/06.
//

import UIKit

class RoundedUIView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 15

    }

}
