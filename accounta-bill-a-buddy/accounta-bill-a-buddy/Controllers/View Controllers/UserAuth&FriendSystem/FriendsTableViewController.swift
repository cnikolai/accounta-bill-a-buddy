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
        print(sender.selectedSegmentIndex)
        print(currentScreen)
    }
    
    //MARK: - Functions
    private func setupViewFor(screen: Screen) {
        searchBar.isHidden = (currentScreen == .requests || currentScreen == .friends)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            returnValue = UserController.sharedInstance.users.count
            break
        case 1:
            returnValue = 0
        case 2:
            returnValue = UserController.sharedInstance.currentUser?.receivedFriendRequests.count ?? 0
        default:
            break
        }
//        if currentScreen == .findFriends {
//            return UserController.sharedInstance.users.count
//        } else if currentScreen == .requests {
//            return UserController.sharedInstance.currentUser?.receivedFriendRequests.count ?? 0
//        } else {
//            return 0
//        }
        print(returnValue)
        return returnValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell else { return UITableViewCell() }
        if currentScreen == .findFriends {
            let user = UserController.sharedInstance.users[indexPath.row]
            cell.user = user
        } else if currentScreen == .requests {
            let request = UserController.sharedInstance.currentUser?.receivedFriendRequests[indexPath.row]
            cell.request = request
        }
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
            UserController.sharedInstance.findUserWith(searchText)
            tableView.reloadData()
        } else if searchText.isEmpty {
            UserController.sharedInstance.users = []
        }
        print(UserController.sharedInstance.users)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
}//End of extension
