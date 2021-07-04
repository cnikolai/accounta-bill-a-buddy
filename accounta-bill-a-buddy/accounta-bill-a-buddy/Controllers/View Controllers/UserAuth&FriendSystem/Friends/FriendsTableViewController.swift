//
//  FriendsTableViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/22/21.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    //MARK: - Properties
    private enum Screen {
        case findFriends
        case friends
        case requests
    }
    private var currentScreen: Screen = .friends {
        didSet {
            setupViewFor(screen: currentScreen)
//            clearTextFieldsFor(screen: currentScreen)
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupViewFor(screen: .friends)
    }
    
    //MARK: - Actions
    @IBAction func segmentedControlButtonTapped(_ sender: UISegmentedControl) {
        tableView.reloadData()
        
        switch sender.selectedSegmentIndex {
        case 0:
            currentScreen = .findFriends
        case 1:
            currentScreen = .friends
        case 2:
            currentScreen = .requests
        default:
            break
        }
    }
    
    //MARK: - Functions
    private func setupViewFor(screen: Screen) {
        searchBar.isHidden = (currentScreen == .requests || currentScreen == .friends)
        if searchBar.isHidden {
            stackViewHeight.constant = 32.0
        } else {
            stackViewHeight.constant = 88.0
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            returnValue = UserController.sharedInstance.users.count
        case 1:
            returnValue = UserController.sharedInstance.currentUser?.friends.count ?? 0
        case 2:
            returnValue = UserController.sharedInstance.currentUser?.receivedFriendRequests.count ?? 0
        default:
            break
        }

        return returnValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell else { return UITableViewCell() }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let user = UserController.sharedInstance.users[indexPath.row]
            cell.user = user
            cell.selectedSegmentIndex = 0
        case 1:
            let friends = UserController.sharedInstance.currentUser?.friends[indexPath.row]
            friends?.forEach({ (key, value) in
                cell.friendsData = [key, value]
            })
            cell.selectedSegmentIndex = 1
        case 2:
            let friendRequest = UserController.sharedInstance.currentUser?.receivedFriendRequests[indexPath.row]
            friendRequest?.forEach({ (key, value) in
                cell.friendRequestData = [key, value]
            })
            cell.selectedSegmentIndex = 2
        default:
            break
        }
        cell.parentVC = self
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}//End of class

//MARK: - Extensions
extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            UserController.sharedInstance.findUser(with: searchText.lowercased())
            tableView.reloadData()
        } else if searchText.isEmpty {
            UserController.sharedInstance.users = []
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
}//End of extension

extension FriendsTableViewController: CustomCellUpdater {
    func updateTableView() {
        tableView.reloadData()
    }
}//End of extension
