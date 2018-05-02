//
//  MemedTableViewController.swift
//  MeMe
//
//  Created by Sai Leung on 4/25/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit

class MemedTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var memeTableView: UITableView!
    var num:Int?
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var memeCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTableView.dataSource = self
        memeTableView.delegate = self
        memeTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // MARK: Table view cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MemeTableViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memedImage.image = meme.memedImage
        cell.memedLabel.text = "\(meme.topText ?? "")...\(meme.bottomText ?? "")"
        return cell
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EditMemedViewController
        destination.num = num
        destination.topText = topText
        destination.bottomText = bottomText
        destination.originalImage = originalImage
    }

    // MARK: Capture meme originalImage
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[(indexPath as NSIndexPath).row]
        if let originalImage = meme.originalImage {
            self.originalImage = originalImage
        }
        
        if let topText = meme.topText {
            print(topText)
            self.topText = topText
        }
        
        if let bottomText = meme.bottomText {
            print(bottomText)
            self.bottomText = bottomText
        }
        num = indexPath.row
        performSegue(withIdentifier: "EditMemedViewControllerSegue", sender: self)
    }
    
    // MARK: Add new meme button
    @IBAction func addNewMemeButton(_ sender: UIBarButtonItem) {
        let loginVC: UIViewController? = storyboard?.instantiateViewController(withIdentifier: "viewController")
        if let loginVC = loginVC {
            present(loginVC, animated: true, completion: nil)
        }
    }
}
