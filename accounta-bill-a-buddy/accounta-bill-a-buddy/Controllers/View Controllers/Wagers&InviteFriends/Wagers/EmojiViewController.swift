//
//  EmojiViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 7/8/21.
//

import UIKit

class EmojiViewController: UIViewController {
    
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self

    }
}

extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCollectionViewCell
        
        cell.emojiImageView.image = UIImage(named: <#T##String#>)
        
        
        return cell
    }
}
