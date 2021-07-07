//
//  WagerCollectionViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "wagerCell"

class WagerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var toDetailView: UIStoryboardSegue!
    
    // Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var dataRef: DocumentReference?
    
    var myWagers: [Wager] = []
    var myFriendsWagers: [Wager] = []
    var wagerRequests: [Wager] = []
    
    //Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadData {
        }
    }
    
    func loadData(completed: @escaping () -> ()) {
        dataRef = db.collection("users").document(UserController.sharedInstance.currentUser!._uid)
        dataRef?.addSnapshotListener { [self] (querySnapshot, error) in
            guard error == nil else {
                print("Error loading data from Firebase listener. --- \(error!)")
                return completed()
            }
            guard let data = querySnapshot else { return }
            createWagerArrays(myWagers: UserController.sharedInstance.currentUser?.myWagers ?? [], myFriendsWagers: UserController.sharedInstance.currentUser?.myFriendsWagers ?? [], wagersRequests: UserController.sharedInstance.currentUser?.wagerRequests ?? []) { success in
                print("Wagers Array updated successfully after listener activated.")
                self.collectionView.reloadData()
            }
            completed()
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
        
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            returnValue = myWagers.count
        case 1:
            returnValue = myFriendsWagers.count
        case 2:
            returnValue = wagerRequests.count
        default: break
        }
        
        return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (view.frame.size.width/3)-25,
            height: (view.frame.size.width/3)-25
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:1, left: 6, bottom: 1, right:6)
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wagerCell", for: indexPath) as? WagerCollectionViewCell else { return UICollectionViewCell() }
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            let myWager = myWagers[indexPath.row]
            cell.myWager = myWager
            cell.selectedSegmentIndex = 0
        case 1:
            let myFriendsWager = myFriendsWagers[indexPath.row]
            cell.myFriendsWager = myFriendsWager
            cell.selectedSegmentIndex = 1
        case 2:
            let wagerRequest = wagerRequests[indexPath.row]
            cell.wagerRequest = wagerRequest
            cell.selectedSegmentIndex = 2
        default:
            break
        }
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            let storyboard = UIStoryboard(name: "WagerDetailView", bundle: nil)
             guard
                 let destinationVC = storyboard.instantiateViewController(identifier: "WagerDetailViewController") as? WagerDetailViewController else {return}
            let wager = myWagers[indexPath.row]
            print("goalDescription", wager.goalDescription)
            destinationVC.wager = wager
            destinationVC.owner = true
            destinationVC.edit = true
            present(destinationVC, animated: true, completion: nil)
        case 1:
            let storyboard = UIStoryboard(name: "WagerDetailView", bundle: nil)
             guard
                 let destinationVC = storyboard.instantiateViewController(identifier: "WagerDetailViewController") as? WagerDetailViewController else {return}
            let wager = myFriendsWagers[indexPath.row]
            print("goalDescription", wager.goalDescription)
            destinationVC.wager = wager
            destinationVC.owner = false
            destinationVC.edit = false
            present(destinationVC, animated: true, completion: nil)
        case 2:
           let storyboard = UIStoryboard(name: "ApproveDenyFriends", bundle: nil)
            guard
                let destinationVC = storyboard.instantiateViewController(identifier: "ApproveDenyFriendsStoryboard") as? AcceptDenyFriendsViewController else {return}
            let wager = wagerRequests[indexPath.row]
            print("goalDescription", wager.goalDescription)
            destinationVC.wager = wager
            present(destinationVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func createWagerArrays(myWagers: [String], myFriendsWagers: [String], wagersRequests: [String], completion: ((Bool) -> Void)?) {
        let group = DispatchGroup()
        
        group.enter()
        WagerController.sharedInstance.createWagerArray(wagerStrings: myWagers) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let wagers):
                    self.myWagers = wagers
                    self.collectionView.reloadData()
                    print("myWagers:", self.myWagers)
                case .failure(let error):
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    break
                }
            }
            group.leave()
        }
        
        group.enter()
        WagerController.sharedInstance.createWagerArray(wagerStrings: myFriendsWagers) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let wagers):
                    self.myFriendsWagers = wagers
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    break
                }
            }
            group.leave()
        }
        
        group.enter()
        WagerController.sharedInstance.createWagerArray(wagerStrings: wagersRequests) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let wagers):
                    self.wagerRequests = wagers
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    break
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(true)
        }
    }
    
} //End of class

//MARK: - Extensions
extension WagerCollectionViewController: DeleteCellDelegate {
    func deleteCellWith(wager: Wager, selectedSegmentIndex: Int) {
        deleteCellAlert(wager: wager, selectedSegmentIndex: selectedSegmentIndex)
    }
    
    func deleteCellAlert(wager: Wager, selectedSegmentIndex: Int) {
        let alertController = UIAlertController(title: "Delete Wager", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            if selectedSegmentIndex == 0 {
                //Delete Wager object from Wagers collection and from current user's myWagers array
                WagerController.sharedInstance.deleteWager(wagerID: wager.wagerID)
                WagerController.sharedInstance.deleteWagerFromMyWagers(wagerToDelete: wager)
                WagerController.sharedInstance.deleteWagerFromFriendsRequests(wagerToDelete: wager)
                WagerController.sharedInstance.deleteWagerFromMyFriendsWagers(wagerToDelete: wager)
                self.collectionView.reloadData()
            } else if selectedSegmentIndex == 1 {
                self.presentLeaveAlert()
                self.collectionView.reloadData()
            } else {
                return
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
    
    func presentLeaveAlert() {
        let leaveAlertController = UIAlertController(title: "Leave Wager", message: "Are you sure you want to leave this wager?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        leaveAlertController.addAction(okAction)
        leaveAlertController.addAction(cancelAction)
        
        present(leaveAlertController, animated: true)
    }
    
} // End of Extension

