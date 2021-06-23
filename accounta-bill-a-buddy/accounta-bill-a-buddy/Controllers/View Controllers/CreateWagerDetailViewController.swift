//
//  CreateWagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class CreateWagerDetailViewController: UIViewController {
    
    // MARK:-Outlets
    @IBOutlet weak var wagerLabel: UIButton!
    @IBOutlet weak var goalLabel: UIButton!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:-Actions
    @IBOutlet weak var photoPickerButtonTapped: UIImageView!
    @IBAction func createWagerButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
