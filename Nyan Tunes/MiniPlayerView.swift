//
//  MiniPlayerView.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 26/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
    let artistLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
    let button = UIButton(frame: CGRect(x: 10, y: 8, width: 25, height: 25))
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 8, width: 25, height: 25))
    let slider = UISlider()
    let bufferProgress = UIProgressView()
    weak var delegate: MiniPlayerViewDelegate?
    
    // MARK: Initialization
    
    override func layoutSubviews() {
        self.frame.size.height = 45
        let width = bounds.size.width
        let height = bounds.size.height
        
        slider.frame = CGRect(x: 0, y: -12, width: width, height: 25)
        slider.setThumbImage(UIImage(named: "slider-thumb"), for: .normal)
        
        bufferProgress.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        bufferProgress.trackTintColor = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.0)
        bufferProgress.progressTintColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        
        slider.minimumTrackTintColor = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.0)
        slider.maximumTrackTintColor = .clear
        
        let playImage = UIImage(named: "play")
        
        button.setImage(playImage, for: .normal)
        button.addTarget(self, action: #selector(MiniPlayerView.togglePlay(button:)), for: .touchDown)
        
        titleLabel.center = CGPoint(x: width/2, y: height/2 - 10)
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.white
        
        artistLabel.center = CGPoint(x: width/2, y:height/2 + 10)
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        artistLabel.textAlignment = NSTextAlignment.center
        artistLabel.textColor = UIColor.white
        
        activityIndicator.center = CGPoint(x:width-30, y:height/2)

        addSubview(bufferProgress)
        addSubview(slider)
        addSubview(activityIndicator)
        addSubview(artistLabel)
        addSubview(titleLabel)
        addSubview(button)
    }
    
    func makeTranslucent() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.insertSubview(blurEffectView, at: 0)
        } else {
            self.backgroundColor = UIColor.black
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        activityIndicator.hidesWhenStopped = true
        slider.isContinuous = true
        slider.addTarget(AudioManager.sharedInstance, action: #selector(AudioManager.sharedInstance.seekTo), for: .valueChanged)
    }
    
    func setPlayButton(playing: Bool){
        if playing == true {
            button.setImage(UIImage.init(named: "pause"), for: .normal)
        } else {
            button.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    func refreshStatus(){
        bufferProgress.progress = 0
        let audioManager = AudioManager.sharedInstance
        self.titleLabel.text = audioManager.playingObject?.title
        self.artistLabel.text = audioManager.playingObject?.artist
        self.setPlayButton(playing: audioManager.isPlaying)
        if audioManager.networkStream {
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.stopAnimating()
        }
    }

    
    // MARK: Button Action
    func togglePlay(button: UIButton) {
        let playing = !AudioManager.sharedInstance.isPlaying
        if playing == true {
            button.setImage(UIImage.init(named: "pause"), for: .normal)
        } else {
            button.setImage(UIImage(named: "play"), for: .normal)
        }
        delegate?.togglePlay()
    }
}

protocol MiniPlayerViewDelegate: class {
    func togglePlay()
}
