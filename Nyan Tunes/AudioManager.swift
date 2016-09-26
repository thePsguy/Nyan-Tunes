//
//  AudioManager.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 27/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

import Foundation
import AVFoundation
import MediaPlayer
import VKSdkFramework

class AudioManager {
    
    private var player = AVPlayer()
    private(set) public var isPlaying: Bool = false
    
    func playNow(obj: VKAudio){
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist: obj.artist, MPMediaItemPropertyTitle: obj.title, MPMediaItemPropertyPlaybackDuration: obj.duration]
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        let playerItem = AVPlayerItem(url: URL(string: obj.url)!)
        player = AVPlayer(playerItem:playerItem)
        player.play()
        self.isPlaying = true
    }
    
    @objc func togglePlay(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus{
        print("received")
        if isPlaying == true {
            pausePlay()
        } else {
            resumePlay()
        }
        return MPRemoteCommandHandlerStatus.success
    }
    
    func pausePlay(){
        player.pause()
        self.isPlaying = false
    }
    
    func resumePlay(){
        player.play()
        self.isPlaying = true
    }
    
    class func sharedInstance() -> AudioManager {
        struct Singleton {
            static var sharedInstance = AudioManager()
        }
        return Singleton.sharedInstance
    }
}
