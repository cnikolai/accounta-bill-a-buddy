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
    
    var wager: Wager? {
        didSet {
            //updateViews()
        }
    }
    var owner: Bool?
    
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
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.hidesBackButton = true;
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
    }
    
    // MARK:-Actions
    @IBAction func progressSliderTapped(_ sender: UISlider) {
        print("slider value: ", sender.value)
        progress = sender.value
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let wager = wager,
              let owner = owner else { return }
        guard let goalDescription = goalDescriptionTextField.text,
              let wagertext = wagerTextField.text,
              let deadline = deadlineTextField.text,
              let progress = progressSlider?.value else { return }
        //update wager in currentview
        wager.goalDescription = goalDescription
        wager.wager = wagertext
        wager.deadline = deadline
        wager.progress = progress
        //update wager in database
        WagerController.sharedInstance.updateWager(wager: wager)
        //update wager in app
        if (owner) {
            UserController.sharedInstance.updateMyWagersList(with: wager)
        }
        else {
            UserController.sharedInstance.updateMyFriendsWagersList(with: wager)

        }
        dismissView()
    }
    
    private func dismissView() {
        self.navigationController?.popViewController(animated: true)
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
