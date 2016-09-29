//
//  ProfileViewController.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 25/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import VKSdkFramework

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    let vkManager: VKClient = {
        return VKClient.sharedInstance
    }()
    var user: VKUser?
    
    override func viewDidLoad() {
        
        print(UserDefaults.standard.bool(forKey:"firstLaunch"))
        
        super.viewDidLoad()
        user = vkManager.getUser()
        imageView.layer.cornerRadius = 36
        nameLabel.text = (user?.first_name)! + " " + (user?.last_name)!
        print(user?.screen_name)
        cityLabel.text = user?.bdate
        countryLabel.text = user?.country?.title
        
        imageView.imageFromServerURL(urlString: (user?.photo_200)!)
    }

    @IBAction func logoutNow(_ sender: AnyObject) {
        VKSdk.forceLogout()
        super.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
