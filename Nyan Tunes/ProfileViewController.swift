//
//  ProfileViewController.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 25/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var musicView: UIView!
    
    let vkManager: VKClient = {
        return VKClient.sharedInstance
    }()
    var user: VKUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = vkManager.getUser()
        imageView.layer.cornerRadius = 36
        nameLabel.text = (user?.first_name)! + " " + (user?.last_name)!
        print(user?.screen_name)
        cityLabel.text = user?.bdate
        countryLabel.text = user?.country?.title
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.profileView.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.profileView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.profileView.insertSubview(blurEffectView, at: 0)
        } else {
            self.view.backgroundColor = UIColor.black
        }
        
        imageView.imageFromServerURL(urlString: (user?.photo_200)!)
    }
    
    @IBAction func logoutNow(_ sender: AnyObject) {
//        UserDefaults.setValue(nil, forKey: "vkToken")
        VKSdk.forceLogout()
        super.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//     MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "musicEmbedSegue"{
            let dest = segue.destination as! ProfileMusicViewController
            self.searchBar.delegate = dest
            dest.searchBar = self.searchBar
        }
    }
}
