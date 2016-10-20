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
import VK_ios_sdk
import CoreAudio

class AudioManager {
    
    static let sharedInstance = AudioManager()
    var delegate: AudioManagerDelegate?
    private var player = AVPlayer()
    private var audioPlayer: AVAudioPlayer?
    private(set) public var isPlaying: Bool = false
    var profileAudioItems = [VKAudio]()
    var downloadedAudioItems = [AudioFile]()
    var playingObject: AudioTableViewCell?
    var networkStream: Bool = false
    var updateTimer = Timer()
    
    private init() {}
    
    func fireTimer(){
        DispatchQueue.main.async {
            self.updateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCurrentTime), userInfo: self.player, repeats: true)
        }
    }
    
    @objc func updateCurrentTime() {
        let time: Float?
        if audioPlayer != nil, (audioPlayer?.isPlaying)! {
            time = Float((audioPlayer?.currentTime)!)
        } else {
            time = Float(player.currentTime().seconds)
        }
        delegate?.playDidProgress(toSeconds: time)
    }
    
    func playNow(obj: AudioTableViewCell){
        pausePlay()
        playingObject = obj
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist: obj.artist.text!, MPMediaItemPropertyTitle: obj.title.text! , MPMediaItemPropertyPlaybackDuration: NSNumber.init(value: obj.duration!)]
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        
        if(obj.audioData != nil){
            do {
                try audioPlayer = AVAudioPlayer.init(data: obj.audioData!)
                audioPlayer!.play()
            } catch {
                obj.title.text = "Invalid Download"
                obj.artist.text = "Delete and download again."
            }
            player.pause()
            networkStream = false
        }else{
            audioPlayer?.stop()
            let playerItem = AVPlayerItem(url: obj.url!)
            networkStream = true
            player = AVPlayer(playerItem:playerItem)
            player.play()
        }
        self.isPlaying = true
        fireTimer()
    }
    
    func availableDuration() -> Float
    {
        var secs: Float = 0
        let range = self.player.currentItem?.loadedTimeRanges.first
        if (range != nil){
            secs = Float(CMTimeRangeGetEnd(range!.timeRangeValue).seconds)
        }
        return secs/Float((playingObject?.duration)!)
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
        if audioPlayer != nil{
            audioPlayer!.pause()
        }
        self.isPlaying = false
        updateTimer.invalidate()
    }
    
    func resumePlay(){
        if !networkStream{
            audioPlayer!.play()
        } else {
            player.play()
        }
        self.isPlaying = true
        self.fireTimer()
    }
    
    @objc func seekTo(sender: UISlider){
        let time = sender.value
        if isPlaying{
            if networkStream{
                player.seek(to: CMTime(seconds: Double(time), preferredTimescale: (player.currentItem?.duration.timescale)!))
            } else {
                audioPlayer?.currentTime = Double(time)
            }
        }
    }
}

protocol AudioManagerDelegate: class {
    func playDidProgress(toSeconds: Float?)
    func stateChanged(playing: Bool, buffering: Bool)
}

extension AudioManagerDelegate {
    func playDidProgress(toSeconds: Float?){}
    func stateChanged(playing: Bool, buffering: Bool){}
}
