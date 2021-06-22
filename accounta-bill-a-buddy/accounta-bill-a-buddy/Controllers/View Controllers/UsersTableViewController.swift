//
//  UsersTableViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/22/21.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
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
    }
    
    //MARK: - Functions
    private func setupViewFor(screen: Screen) {
        searchBar.isHidden = (currentScreen == .requests)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.sharedInstance.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell else { return UITableViewCell() }
        let user = UserController.sharedInstance.users[indexPath.row]
        cell.user = user
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }

}//End of class

//MARK: - Extensions
extension UsersTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserController.sharedInstance.findUserWith(searchText)
        tableView.reloadData()
        print(UserController.sharedInstance.users)
    }
    
}//End of extension
