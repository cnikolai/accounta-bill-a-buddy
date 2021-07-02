//
//  InviteFriendsListTableViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 7/1/21.
//

import UIKit


protocol InviteFriendsListTableViewControllerDelegate: AnyObject {
    func passFriends(_ sender: InviteFriendsListTableViewController)
}

class InviteFriendsListTableViewController: UIViewController {

    // MARK:- Properties
    var friend: [String:String]?
    var wagerFriends: [String] = []
    //var invitedFriend: [String: String] = []

    // MARK:-Outlets
    @IBOutlet weak var tableView: UITableView!
    weak static var delegate: InviteFriendsListTableViewControllerDelegate?

    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        InviteFriendsListTableViewController.delegate?.passFriends(self)
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
        
        cell.delegate = self
        cell.friend = friend
        
        return cell
    }
}

extension InviteFriendsListTableViewController: InviteFriendsTableViewCellDelegate {
    func saveFriends(_ sender: InviteFriendsTableViewCell) {
        sender.toggleButton()
        
    //invitedFriend = sender.friend ?? [:]
        
//        if sender.inviteWagerFriend {
//            wagerFriends.append(sender.friendNameLabel.text ?? "unknown")
//        } else if let person = sender.friendNameLabel.text,
//                  let index = wagerFriends.firstIndex(of: person) {
//                wagerFriends.remove(at: index)
//        }
//        if sender.inviteWagerFriend {
//            wagerFriends.append(sender.friend[String: String])
//        } else if let person = sender.friend,
//                  let index = wagerFriends.firstIndex(of: person) {
//                wagerFriends.remove(at: index)
//        }
        
        print(wagerFriends)
    }
}
