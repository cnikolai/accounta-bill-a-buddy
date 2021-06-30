//
//  WagerCollectionViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

private let reuseIdentifier = "wagerCell"

class WagerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    var wagers: [Wager] = [] //["basketball", "football", "gym", "soccer", "tennis"]
    
    var toDetailView: UIStoryboardSegue!
    
    // Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(WagerCollectionViewCell.self, forCellWithReuseIdentifier: "wagerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        WagerController.sharedInstance.createDummyWagers()
        wagers = WagerController.sharedInstance.wagers
        //       self.toDetailView = UIStoryboardSegue(identifier: "toDetailView", source: self, destination: WagerDetailViewController as? UIViewController   ?? nil)
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
    
    @IBAction func segmentedControllerTapped(_ sender: Any) {
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var returnValue = 0
//        switch segmentedController.selectedSegmentIndex {
//        case 0:
//            returnValue = UserController.sharedInstance.currentUser?.ownedWagers.count ?? 0
//        case 1:
//            returnValue = UserController.sharedInstance.currentUser?.acceptedWagers.count ?? 0
//        case 2:
//            returnValue = UserController.sharedInstance.currentUser?.pendingWagers.count ?? 0
//        default: break
//        }
//        return returnValue
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wagerCell", for: indexPath) as? WagerCollectionViewCell else {return UICollectionViewCell()}
        
        let wager = wagers[indexPath.row]
        // cell.wager = wager
        // cell.wagerImageView.image = wager.wagerPhoto
        cell.delegate = self
       // cell.isEditing = collectionView.isEditing
        
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWagerDetailVC" {
            guard
                let destinationVC = segue.destination as? WagerDetailViewController,
                let cell = sender as? WagerCollectionViewCell,
                let indexPath = self.collectionView!.indexPath(for: cell) else {return}
            // let indexPath = self.WagerCollectionViewCell.indexPath(for: cell) else {return}
            
            let wager = WagerController.sharedInstance.wagers[indexPath.row]
            // print("goalDescription", wager.goalDescription)
            destinationVC.wager = wager
        }
    }
    
} //End of class

extension WagerCollectionViewController: DeleteCellDelegate {
    func deleteCellWith(wager: Wager) {
        deleteCellAlert(wager: wager)

    }

    func deleteCellAlert(wager: Wager) {
        
        let alertController = UIAlertController(title: "Delete Wager?", message: "Are you sure you want to delete?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            (_) in
//            let index2 = self.wagers.firstIndex(of: wager)
//            print(index2)
            guard let index = self.wagers.firstIndex(of: wager) else {return}
            print(wager.goalDescription)
            self.wagers.remove(at: index)
            self.collectionView.reloadData()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        present(alertController, animated: true)
    }
} // End of Extension

