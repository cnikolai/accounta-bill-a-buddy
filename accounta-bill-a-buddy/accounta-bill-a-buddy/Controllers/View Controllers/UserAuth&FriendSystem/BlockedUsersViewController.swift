//
//  BlockedUsersViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/30/21.
//

import UIKit

class BlockedUsersViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Actions
    
    //MARK: - Functions

}//End of class

//MARK: - Extensions
extension BlockedUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.sharedInstance.currentUser?.blockedUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blockedUserCell") as? BlockedUserTableViewCell else { return UITableViewCell() }
        let blockedUser = UserController.sharedInstance.currentUser?.blockedUsers[indexPath.row]
        cell.blockedUser = blockedUser
        return cell
    }
}//End of extension

extension BlockedUsersViewController: UnblockUserCellDelegate {
    func unblockUser() {
        tableView.reloadData()
    }
}//End of extension
