//
//  MemedCollectionViewController.swift
//  MeMe
//
//  Created by Sai Leung on 4/28/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit

class MemedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var memedCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var num:Int?
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedCollectionView.dataSource = self
        memedCollectionView.delegate = self
        
        // Mark: Collection View Item Layout
        let space: CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memedCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // MARK: Collection item configuration
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MemedCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memedImage.image = meme.memedImage
        return cell
    }

    // MARK: Collection item pressed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // MARK: Capture originalImage
        if let originalImage = meme.originalImage {
            self.originalImage = originalImage
        }
        
        // MARK: Capture topText
        if let topText = meme.topText {
            print(topText)
            self.topText = topText
        }
        
        // MARK: Capture bottomText
        if let bottomText = meme.bottomText {
            print(bottomText)
            self.bottomText = bottomText
        }
        
        num = indexPath.row
        performSegue(withIdentifier: "CollectionViewControllerSegue", sender: self)
    }
    
    // MARK: Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EditMemedViewController
        destination.num = num
        destination.topText = topText
        destination.bottomText = bottomText
        destination.originalImage = originalImage
    }
    
    @IBAction func addNewMemeButton(_ sender: UIBarButtonItem) {
        let loginVC: UIViewController? = storyboard?.instantiateViewController(withIdentifier: "viewController")
        if let loginVC = loginVC {
            present(loginVC, animated: true, completion: nil)
        }
    }
    
}
