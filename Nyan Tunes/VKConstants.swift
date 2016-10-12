//
//  VKConstants.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 25/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VK_ios_sdk

extension VKClient {

    struct Constants{
        static let appID = "5646851"
        static let SCOPE: [Any] = [VK_PER_FRIENDS, VK_PER_PHOTOS, VK_PER_AUDIO, VK_PER_OFFLINE]
        static let VK_ACCESS_TOKEN_DEFAULTS_KEY: String = "VK_ACCESS_TOKEN_DEFAULTS_KEY_DONT_TOUCH_THIS_PLEASE";
    }
}
