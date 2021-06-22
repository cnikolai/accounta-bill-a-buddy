//
//  WagerCollectionViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 6/22/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class WagerCollectionViewController: UICollectionViewController {
    
    let wagers = ["basketball", "football", "gym", "soccer", "tennis"]
    
    @IBOutlet var wagerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wagerCollectionView.delegate = self
        wagerCollectionView.dataSource = self
        
        // Register cell classes
//        wagerCollectionView.register(WagerCollectionViewCell.self, forCellWithReuseIdentifier: WagerCollectionViewCell.identifier)
        
    }
    
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return wagers.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wagerCell", for: indexPath) as! WagerCollectionViewCell
            
            cell.wagerImageView.image = UIImage(named: wagers[indexPath.row])
            cell.layer.cornerRadius = cell.frame.height / 2
            
            return cell
        }
    
}

