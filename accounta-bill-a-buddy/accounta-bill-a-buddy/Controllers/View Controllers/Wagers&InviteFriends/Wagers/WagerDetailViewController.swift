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
    
    var wager: Wager?
    
    // MARK:-Outlets
    @IBOutlet weak var goalDescriptionTextField: UITextField!
    
    @IBOutlet weak var wagerTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var wagerPhotoImageView: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    
    // MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
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
    
    func updateViews() {
        guard let wager = wager else {return}
        wagerPhotoImageView.image = wager.wagerPhoto
        goalDescriptionTextField.text = wager.goalDescription
        deadlineTextField.text = wager.deadline
        wagerTextField.text = wager.wager
        progressSlider.value = wager.progress
    }

}
