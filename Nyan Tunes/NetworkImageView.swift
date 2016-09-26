//
//  NetworkImageView.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 26/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class NetworkImageView: UIImageView {
    
    public func imageFromServerURL(urlString: String) {
            URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self.image = image
                }
            }).resume()
        }

}
