//
//  WagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class WagerDetailViewController: UIViewController {

    // MARK:-Outlets
    @IBOutlet weak var goalDescriptionLabel: UITextField!
    @IBOutlet weak var wagerTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:-Actions
    @IBAction func progressSliderTapped(_ sender: Any) {
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
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
