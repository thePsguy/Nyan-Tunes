//
//  NowPlayingAudioItem.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 21/10/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

class NowPlayingAudioItem:NSObject {

    var title: String?
    var artist: String?
    var url: URL?
    var audioData: Data?
    var duration: Int!
    var trackBytes: Int?
    
    init(title: String?, artist: String?, url: URL?, audioData: Data?, duration: Int, trackBytes: Int?) {
        self.title = title
        self.artist = artist
        self.url = url
        self.audioData = audioData
        self.duration = duration
        self.trackBytes = trackBytes
    }
}
