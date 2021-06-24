//
//  WagerCollectionViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

class WagerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wagerImageView: UIImageView!
    
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    
    var isinEditingMode: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isinEditingMode
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isinEditingMode {
                checkmarkLabel.text = isSelected ? "✓" : ""
            }
        }
    }
    
    
}
