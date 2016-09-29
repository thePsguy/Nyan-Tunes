//
//  UIViewController+showAlert.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 29/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(text: String){
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
