//
//  WagerCollectionViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

private let reuseIdentifier = "wagerCell"

class WagerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var toDetailView: UIStoryboardSegue!
    
    // Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myWagers: [Wager] = []
    var myFriendsWagers: [Wager] = []
    var wagerRequests: [Wager] = []
    
    //Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(WagerCollectionViewCell.self, forCellWithReuseIdentifier: "wagerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        createWagerArrays(myWagers: UserController.sharedInstance.currentUser?.myWagers ?? [], myFriendsWagers: UserController.sharedInstance.currentUser?.myFriendsWagers ?? [], wagersRequests: UserController.sharedInstance.currentUser?.wagerRequests ?? []) { success in
            print("Wagers Array created successfully")
        }
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
    
    func tempFuncFetchWagers() {
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        let wagersArray = currentUser.myWagers
        print(wagersArray)
    }
    
    //    @IBAction func segmentedControllerTapped(_ sender: Any) {
    //        switch segmentedController.selectedSegmentIndex {
    //        case 0:
    //            let wagersArray = UserController.sharedInstance.fetchMyWagers()
    //            print(wagersArray)
    //        default: break
    //        }
    //    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = 0
        switch segmentedController.selectedSegmentIndex {
        case 0:
            returnValue = UserController.sharedInstance.currentUser?.myWagers.count ?? 0
        case 1:
            returnValue = UserController.sharedInstance.currentUser?.myFriendsWagers.count ?? 0
        case 2:
            returnValue = UserController.sharedInstance.currentUser?.wagerRequests.count ?? 0
        default: break
        }
        return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wagerCell", for: indexPath) as? WagerCollectionViewCell else {return UICollectionViewCell()}
        
        return cell
        
        //        switch segmentedControl.selectedSegmentIndex {
        //        case 0:
        //            let user = UserController.sharedInstance.users[indexPath.row]
        //            cell.user = user
        //            cell.selectedSegmentIndex = 0
        //        case 1:
        //            let friends = UserController.sharedInstance.currentUser?.friends[indexPath.row]
        //            friends?.forEach({ (key, value) in
        //                cell.friendsData = [key, value]
        //            })
        //            cell.selectedSegmentIndex = 1
        //        case 2:
        //            let friendRequest = UserController.sharedInstance.currentUser?.receivedFriendRequests[indexPath.row]
        //            friendRequest?.forEach({ (key, value) in
        //                cell.friendRequestData = [key, value]
        //            })
        //            cell.selectedSegmentIndex = 2
        //        default:
        //            break
    }
    
    func createWagerArrays(myWagers: [String], myFriendsWagers: [String], wagersRequests: [String], completion: ((Bool) -> Void)?) {
        
        let myWagers = WagerController.sharedInstance.createWagerArray(wagerStrings: myWagers)
        let myFriendsWagers = WagerController.sharedInstance.createWagerArray(wagerStrings: myFriendsWagers)
        let wagerRequests = WagerController.sharedInstance.createWagerArray(wagerStrings: wagersRequests)
        
        self.myWagers = myWagers
        self.myFriendsWagers = myFriendsWagers
        self.wagerRequests = wagerRequests
        print(self.myWagers)
        print(self.myFriendsWagers)
        print(self.wagerRequests)
        completion?(true)
        
    }
    
    
    //let wager = wagers[indexPath.row]
    
    // cell.wager = wager
    // cell.wagerImageView.image = wager.wagerPhoto
    // cell.delegate = self
    // cell.isEditing = collectionView.isEditing
    
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

//extension WagerCollectionViewController: DeleteCellDelegate {
////    func deleteCellWith(wager: Wager) {
////        deleteCellAlert(wager: wager)
//
//    }
//
////    func deleteCellAlert(wager: Wager) {
////
////        let alertController = UIAlertController(title: "Delete Wager?", message: "Are you sure you want to delete?", preferredStyle: .alert)
////
////        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
////
////        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
////            (_) in
//////            let index2 = self.wagers.firstIndex(of: wager)
//////            print(index2)
////            guard let index = self.wagers.firstIndex(of: wager) else {return}
////            print(wager.goalDescription)
////            self.wagers.remove(at: index)
////            self.collectionView.reloadData()
////        }
////
////        alertController.addAction(cancelAction)
////        alertController.addAction(deleteAction)
////
////        present(alertController, animated: true)
////    }
//} // End of Extension

