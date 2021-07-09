//
//  EmojiViewController.swift
//  accounta-bill-a-buddy
//
//  Created by Rishi Kolappa on 7/8/21.
//

import UIKit

protocol EmojiViewControllerDelegate: AnyObject {
    func saveEmoji(_ emoji: UIImage)
}

class EmojiViewController: UIViewController {

    // MARK:-Properties
    var emojis = [0x1F603, 0x1F602, 0x1F911, 0x1F634, 0x1F973, 0x1F970, 0x1F3CA, 0x26F9, 0x1F3CB, 0x1F984, 0x1F420, 0x1F98B, 0x1F338, 0x1F333, 0x1F340, 0x1F34E, 0x2615, 0x1F3DD, 0x1F698, 0x1F6B2, 0x1F680, 0x231B, 0x1F3C6, 0x1F3A8, 0x1F4BB, 0x1F4A1, 0x270F]
    var emojiSelected: UIImage?
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    static weak var delegate: EmojiViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCollectionViewCell
        
        cell.emojiImageView.image = String(UnicodeScalar(emojis[indexPath.row])!).image(fontSize:100)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        emojiSelected = String(UnicodeScalar(emojis[indexPath.row])!).image(fontSize:100)
        EmojiViewController.delegate?.saveEmoji(emojiSelected!)

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
