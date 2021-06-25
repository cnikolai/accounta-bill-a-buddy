//
//  WagerCollectionViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

private let reuseIdentifier = "wagerCell"

class WagerCollectionViewController: UICollectionViewController {
    
    var wagers = ["basketball", "football", "gym", "soccer", "tennis"]
    
    // Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Actions
    @IBAction func editButtonTapped(_ sender: Any) {
        
        collectionView.isEditing.toggle()
        collectionView.reloadData()
        
        if collectionView.isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        collectionView.allowsMultipleSelection = editing
//        let indexPaths = collectionView.indexPathsForVisibleItems
//        for indexPath in indexPaths {
//            let cell = collectionView.cellForItem(at: indexPath) as! WagerCollectionViewCell
//            cell.isinEditingMode = editing
//        }
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wagers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wagerCell", for: indexPath) as? WagerCollectionViewCell else {return UICollectionViewCell()}
        
        let wager = wagers[indexPath.row]
        cell.wager = wager
        cell.delegate = self
        cell.isEditing = collectionView.isEditing
        
        //cell.layer.cornerRadius = cell.frame.height / 2
        //cell.isinEditingMode = isEditing
        
        return cell
    }
    
} //End of class

extension WagerCollectionViewController: DeleteCellDelegate {
    func deleteCellWith(wager: String) {
        deleteCellAlert(wager: wager)

    }
    
    func deleteCellAlert(wager: String) {
        let alertController = UIAlertController(title: "Delete Wager?", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            (_) in
            guard let index = self.wagers.firstIndex(of: wager) else {return}
           self.wagers.remove(at: index)
            self.collectionView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
} // End of Extension

