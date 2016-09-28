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
import CoreAudio

class AudioManager {
    
    static let sharedInstance = AudioManager()
    private init() {}
    
    var delegate: AudioManagerDelegate?
    
    private var player = AVPlayer()
    private var audioPlayer: AVAudioPlayer?
    private(set) public var isPlaying: Bool = false
    var profileAudioItems = [VKAudio]()
    var downloadedAudioItems = [AudioFile]()
    var playingObject: AudioTableViewCell?
    var networkStream: Bool = false
    
    func playNow(obj: AudioTableViewCell){
        playingObject = obj
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist: obj.artist.text!, MPMediaItemPropertyTitle: obj.title.text! , MPMediaItemPropertyPlaybackDuration: NSNumber.init(value: Int(obj.duration!)!)]
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        if(obj.audioData != nil){
            audioPlayer = try! AVAudioPlayer.init(data: obj.audioData!)
            audioPlayer!.play()
            player = AVPlayer()
            networkStream = false
        }else{
            audioPlayer = nil
            var playerItem: AVPlayerItem?
            playerItem = AVPlayerItem(url: obj.url!)
            networkStream = true
            player = AVPlayer(playerItem:playerItem)
            player.play()
        }
        self.isPlaying = true
    }
    
    @objc func togglePlay(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus{
        print("received")
        
        func availableDuration() -> CMTime
        {
            let range = self.player.currentItem?.loadedTimeRanges.first
            if (range != nil){
                return CMTimeRangeGetEnd(range!.timeRangeValue)
            }
            return kCMTimeZero
        }

       CMTimeShow(availableDuration())
        
        if isPlaying == true {
            pausePlay()
        } else {
            resumePlay()
        }
        return MPRemoteCommandHandlerStatus.success
    }
    
    func pausePlay(){
        player.pause()
        if audioPlayer != nil{
            audioPlayer!.pause()
        }
        self.isPlaying = false
    }
    
    func resumePlay(){
        player.play()
        if audioPlayer != nil{
            audioPlayer!.play()
        }
        self.isPlaying = true
    }
    
}

protocol AudioManagerDelegate: class {
    func stateChanged(playing: Bool, buffering: Bool)
}
