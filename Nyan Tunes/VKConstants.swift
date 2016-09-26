//
//  VKConstants.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 25/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VKSdkFramework

extension VKClient {

    struct Constants{
        static let appID = "5367882"
        static let SCOPE: [Any] = [VK_PER_FRIENDS, VK_PER_PHOTOS, VK_PER_AUDIO, VK_PER_OFFLINE]
    }
}
