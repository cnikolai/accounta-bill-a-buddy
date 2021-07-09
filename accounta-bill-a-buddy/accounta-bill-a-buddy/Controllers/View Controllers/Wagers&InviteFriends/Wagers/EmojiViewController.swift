//
//  EmojiViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 7/8/21.
//

import UIKit

protocol EmojiViewControllerDelegate: AnyObject {
    func saveEmoji(_ sender: EmojiViewController)
}

class EmojiViewController: UIViewController {
    
    // MARK:-Properties
    var emojis = [0x1F601,0x1F64F,
                  0x2702,0x27B0,
                  0x1F680,0x1F6C0,
                  0x1F170,0x1F251]
    var emojiSelected: UIImage?
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    static weak var delegate: EmojiViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
    }
}

extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCollectionViewCell
        

        cell.emojiImageView.image = String(UnicodeScalar(emojis[indexPath.row])!).image(fontSize:100)
        emojiSelected = cell.emojiImageView.image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EmojiViewController.delegate?.saveEmoji(self)
        self.dismiss(animated: true, completion: nil)
    }
}

extension String
{
    func image(fontSize:CGFloat = 40, bgColor:UIColor = UIColor.clear, imageSize:CGSize? = nil) -> UIImage?
    {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let imageSize = imageSize ?? self.size(withAttributes: attributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        bgColor.set()
        let rect = CGRect(origin: .zero, size: imageSize)
        UIRectFill(rect)
        self.draw(in: rect, withAttributes: [.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
