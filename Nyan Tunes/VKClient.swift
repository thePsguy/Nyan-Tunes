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
    
    var User: VKUser!
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

    func sessionExistsWith(_ SCOPE: [Any], completion: @escaping (Bool) -> Void){
        VKSdk.wakeUpSession(SCOPE, complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            if (state == VKAuthorizationState.authorized) {
                self.User = VKSdk.accessToken().localUser
                completion(true)
            }
            else if (error != nil) {
                print("Error:",error)
                completion(false)
            }else{
                completion(false)
            }
        })
    }
    func authorize(_ SCOPE: [Any]){
        VKSdk.authorize(SCOPE)
    }
}
