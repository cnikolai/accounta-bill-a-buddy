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
        //        collectionView.register(WagerCollectionViewCell.self, forCellWithReuseIdentifier: "wagerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        createWagerArrays(myWagers: UserController.sharedInstance.currentUser?.myWagers ?? [], myFriendsWagers: UserController.sharedInstance.currentUser?.myFriendsWagers ?? [], wagersRequests: UserController.sharedInstance.currentUser?.wagerRequests ?? []) { success in
            print("Wagers Array created successfully")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        //        print("wagersArray:", wagersArray)
    }
    
        @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
            collectionView.reloadData()
        }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
        
        return cell
    }
    
    func createWagerArrays(myWagers: [String], myFriendsWagers: [String], wagersRequests: [String], completion: ((Bool) -> Void)?) {
        let group = DispatchGroup()
        
        //NOTE: Repeating code here, fix
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
            
//            let wager = WagerController.sharedInstance.wagers[indexPath.row]
//            // print("goalDescription", wager.goalDescription)
//            destinationVC.wager = wager
        }
    }
    
} //End of class

//MARK: - Extensions
//extension WagerCollectionViewController: DeleteCellDelegate {
//    func deleteCellWith(wager: Wager) {
//        deleteCellAlert(wager: wager)

//    }

//    func deleteCellAlert(wager: Wager) {
//
//        let alertController = UIAlertController(title: "Delete Wager?", message: "Are you sure you want to delete?", preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
//            (_) in
//            let index2 = self.wagers.firstIndex(of: wager)
//            print(index2)
//            guard let index = self.wagers.firstIndex(of: wager) else {return}
//            print(wager.goalDescription)
//            self.wagers.remove(at: index)
//            self.collectionView.reloadData()
//        }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(deleteAction)
//
//        present(alertController, animated: true)
//    }
//} // End of Extension
