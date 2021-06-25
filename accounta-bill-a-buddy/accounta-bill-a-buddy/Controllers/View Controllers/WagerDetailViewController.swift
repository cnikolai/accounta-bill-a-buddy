//
//  WagerDetailViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/23/21.
//

import UIKit

class WagerDetailViewController: UIViewController {

    // MARK:-Properties
    var progress: Float?
    
    // MARK:-Outlets
    @IBOutlet weak var goalDescriptionLabel: UITextField!
    @IBOutlet weak var wagerTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:-Actions
    @IBAction func progressSliderTapped(_ sender: UISlider) {
        print("slider value: ", sender.value)
        progress = sender.value
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        //cmn - update wager
        dismissView()
    }
    
    private func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
