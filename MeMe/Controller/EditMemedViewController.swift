//
//  EditMemedViewController.swift
//  MeMe
//
//  Created by Sai Leung on 4/26/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit

class EditMemedViewController: UIViewController {
   
    @IBOutlet weak var editMemedImage: UIImageView!
    var num: Int?
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {

        // MARK: Presenting memed image
        if let num = num {
            let meme = memes[num]
            editMemedImage.image = meme.memedImage
        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        num = nil
    }

    @IBAction func editButton(_ sender: UIBarButtonItem) {
                let controller = storyboard!.instantiateViewController(withIdentifier: "viewController") as! ViewController
        
        // MARK: Passing memed image to viewController for editing
                controller.originalImage = originalImage
                controller.topText = topText
                controller.bottomText = bottomText
                num = 1
                controller.num = num
                present(controller, animated: true, completion: nil)
    }
    
}
