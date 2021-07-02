//
//  InviteFriendsListTableViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit

class InviteFriendsListTableViewController: UIViewController {

    // MARK:- Properties
    var friend: [String:String]?

    // MARK:-Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension InviteFriendsListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.sharedInstance.currentUser?._friends.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsCell", for: indexPath) as? InviteFriendsTableViewCell else { return UITableViewCell()}
             let friend = UserController.sharedInstance.currentUser?._friends[indexPath.row]
             cell.friend = friend
             return cell
    }
}
