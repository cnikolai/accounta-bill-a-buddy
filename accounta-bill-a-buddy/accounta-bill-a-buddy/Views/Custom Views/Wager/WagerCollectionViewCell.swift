//
//  WagerCollectionViewCell.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

protocol DeleteCellDelegate: AnyObject {
    func deleteCellWith(wager: Wager, selectedSegmentIndex: Int)
}

class WagerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var wagerImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: DeleteCellDelegate?
    var selectedSegmentIndex: Int?
    var myWager: Wager? {
        didSet {
            updateMyWagersView()
        }
    }
    var myFriendsWager: Wager? {
        didSet {
            updateMyFriendsWagersView()
        }
    }
    var wagerRequest: Wager? {
        didSet {
            updateRequestedView()
        }
    }
    
//  //  var isEditing = false {
//      //  didSet {
//       //     deleteButton.isHidden = !isEditing
//        }
//    }
    
    //MARK: - Actions
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if selectedSegmentIndex == 0  {
            guard let myWager = myWager else { return }
            print(myWager.wagerID)
            delegate?.deleteCellWith(wager: myWager, selectedSegmentIndex: 0)
        } else if selectedSegmentIndex == 1 {
            guard let myFriendsWager = myFriendsWager else { return }
            delegate?.deleteCellWith(wager: myFriendsWager, selectedSegmentIndex: 1)
        } else if selectedSegmentIndex == 2 {
            guard let wagerRequest = wagerRequest else { return }
            delegate?.deleteCellWith(wager: wagerRequest, selectedSegmentIndex: 2)
        } else {
            return
        }
    }
    
    //MARK: - Functions
    func updateMyWagersView() {
        guard let myWager = myWager else {return}
        wagerImageView?.image = myWager.wagerPhoto
        wagerImageView?.layer.cornerRadius = wagerImageView.frame.height / 2
    }
    
    func updateMyFriendsWagersView() {
        guard let myFriendsWager = myFriendsWager else {return}
        wagerImageView?.image = myFriendsWager.wagerPhoto
        wagerImageView?.layer.cornerRadius = wagerImageView.frame.height / 2
    }
    
    func updateRequestedView() {
        guard let wagerRequest = wagerRequest else {return}
        print(wagerRequest.wagerID)
        wagerImageView?.image = wagerRequest.wagerPhoto
        wagerImageView?.layer.cornerRadius = wagerImageView.frame.height / 2
    }
    
}//End of class
