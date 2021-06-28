//
//  WagerCollectionViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

protocol DeleteCellDelegate: AnyObject {
    func deleteCellWith(wager: Wager)
}

class WagerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wagerImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var wager: Wager? {
        didSet {
            updateViews()
        }
    }
    
    var isEditing = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    weak var delegate: DeleteCellDelegate?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let wager = wager else {return}
        delegate?.deleteCellWith(wager: wager)
    }
    
    func updateViews() {
        guard let wager = wager else {return}
        wagerImageView.image = wager.wagerPhoto
        wagerImageView.layer.cornerRadius = wagerImageView.frame.height / 2

    }
    
}
