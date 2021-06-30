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

    }
    
    //MARK: - Actions
    
    //MARK: - Functions

}//End of class

//MARK: - Extensions
extension BlockedUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blockedUserCell") as? BlockedUserTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}//End of extension
