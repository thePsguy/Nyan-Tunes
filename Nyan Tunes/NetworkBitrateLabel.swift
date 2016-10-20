//
//  NetworkBitrateLabel.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 20/10/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class NetworkBitrateLabel: UILabel {

    var bitRateSet = false
    
    func setBitrateFromUrl(url: URL, withTrackLength length: Int, forceLoad: Bool? = false){
        if bitRateSet == false || forceLoad == true{
            var headerRequest = URLRequest(url: url)
            headerRequest.httpMethod = "HEAD"
        
            NSURLConnection.sendAsynchronousRequest(headerRequest, queue: .main) { (response, data, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let size = httpResponse.expectedContentLength
                    print("Size, Length: ",size, length)
                    self.text = "\((size*8/1024)/Int64(length)) kbps"
                    self.bitRateSet = true
                }
            }
        }
    }
}
