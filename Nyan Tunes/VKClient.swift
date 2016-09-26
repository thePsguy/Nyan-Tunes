//
//  VKClient.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 25/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VKSdkFramework

class VKClient {
    
    var User: VKUser?
    var SDKvk: VKSdk!
    
//    init(VKDelegate: VKSdkDelegate, VkUiDelegate: VKSdkUIDelegate) {
//        SDKvk = VKSdk.initialize(withAppId: VKClient.Constants.appID)
//        SDKvk.register(VKDelegate)
//        SDKvk.uiDelegate = VkUiDelegate
//    }

    
    class func sharedInstance() -> VKClient {
        struct Singleton {
            static var sharedInstance = VKClient()
        }
        return Singleton.sharedInstance
    }
}
