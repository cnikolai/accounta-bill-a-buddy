//
//  FriendsViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Jenny Morales on 6/18/21.
//

import UIKit

class UserssViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var findFriendsSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    //MARK: - Functions

}//End of class

//MARK: - Extensions
extension UserssViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendTableViewCell else { return UITableViewCell() }
        return cell
    }
}//End of extension

extension UserssViewController: UISearchBarDelegate {
    
}//End of extension
