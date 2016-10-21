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
    var currentIndex = 0
    var playingObject : NowPlayingAudioItem?
    var networkStream: Bool = false
    var updateTimer = Timer()
    
    
    private init() {}
    
    func fireTimer(){
        DispatchQueue.main.async {
            self.updateTimer.invalidate()
            self.updateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCurrentTime), userInfo: self.player, repeats: true)
        }
    }
    
    func invalidateTimer(){
        DispatchQueue.main.async {
            self.updateTimer.invalidate()
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
    
    func updateControlCenter(){
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist: playingObject!.artist, MPMediaItemPropertyTitle: playingObject!.title, MPMediaItemPropertyPlaybackDuration: NSNumber.init(value: playingObject!.duration)]
    }
    
    func playNow(obj: AudioTableViewCell?){
        pausePlay()
        if obj != nil{
            setNowPlaying(title: (obj?.title.text!)!, artist: (obj?.artist.text!)!, url: (obj?.url!)!, audioData: obj?.audioData, duration: (obj?.duration!)!, trackBytes: obj?.trackBytes)
            if obj?.audioData != nil {
                currentIndex = downloadedAudioItems.index(where: { (file: AudioFile) -> Bool in
                    return file.title == playingObject?.title && file.artist == playingObject?.artist
                })!
            }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist: playingObject!.artist, MPMediaItemPropertyTitle: playingObject!.title, MPMediaItemPropertyPlaybackDuration: NSNumber.init(value: playingObject!.duration)]
//        updateControlCenter()
        
        updateCurrentTime()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        if(playingObject?.audioData != nil){
            do {
                try audioPlayer = AVAudioPlayer.init(data: (playingObject?.audioData!)!)
                NotificationCenter.default.addObserver(self, selector: #selector(self.nextTrack), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer)
                audioPlayer!.play()
            } catch {
                obj?.title.text = "Invalid Download"
                obj?.artist.text = "Delete and download again."
                nextTrack(event: nil)
            }
            player.pause()
            networkStream = false
        }else{
            audioPlayer?.stop()
            let playerItem = AVPlayerItem(url: (obj?.url)!)
            networkStream = true
            player = AVPlayer(playerItem:playerItem)
            player.play()
        }
        self.isPlaying = true
        fireTimer()
    }
    
    func setNowPlaying(title: String, artist: String, url: URL, audioData:Data?, duration: Int, trackBytes: Int?){
        playingObject = NowPlayingAudioItem(title: title, artist: artist, url: url, audioData: audioData, duration: duration, trackBytes: trackBytes)
    }
    
    @objc func nextTrack(event: MPRemoteCommandEvent?) -> MPRemoteCommandHandlerStatus{
            if networkStream{
                return .noSuchContent
            } else {
                    currentIndex = currentIndex < downloadedAudioItems.count - 1 ? currentIndex + 1 : 0
                    let currentItem = downloadedAudioItems[currentIndex]
                setNowPlaying(title: currentItem.title!, artist: currentItem.artist!, url: URL(string: currentItem.url!)!, audioData: currentItem.audioData as? Data, duration: Int(currentItem.duration!)!, trackBytes: nil)
                    playNow(obj: nil)
                    return .success
            }
    }
    
    @objc func previousTrack(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus{
        if networkStream {
            
        } else {
                currentIndex = currentIndex > 0  ? currentIndex - 1 : downloadedAudioItems.count - 1
                let currentItem = downloadedAudioItems[currentIndex]
                setNowPlaying(title: currentItem.title!, artist: currentItem.artist!, url: URL(string: currentItem.url!)!, audioData: currentItem.audioData as? Data, duration: Int(currentItem.duration!)!, trackBytes: nil)
                playNow(obj: nil)
                return .success
        }
        return .noSuchContent
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
        invalidateTimer()
        let time = sender.value
        if isPlaying{
            if networkStream && Double(time) < (player.currentItem?.duration.seconds)!{
                player.seek(to: CMTime(seconds: Double(time), preferredTimescale: (player.currentItem?.duration.timescale)!))
                player.pause()
                player.play()
            } else if !networkStream {
                audioPlayer?.currentTime = Double(time)
            }
            fireTimer()
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
