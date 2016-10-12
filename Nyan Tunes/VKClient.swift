//
//  VKClient.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 25/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKClient {
    
    var User: VKUser?
    var SDKvk: VKSdk!
    
    static let sharedInstance = VKClient()
    private init() {}
    
}
