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
    weak var delegate: MiniPlayerViewDelegate?
    
    // MARK: Initialization
    
    override func layoutSubviews() {
        let width = bounds.size.width
        let height = bounds.size.height
        
        button.setImage(UIImage(named: "play"), for: .normal)
        
        button.addTarget(self, action: #selector(MiniPlayerView.togglePlay(button:)), for: .touchDown)
        
        titleLabel.center = CGPoint(x: width/2, y: height/2 - 10)
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        titleLabel.textAlignment = NSTextAlignment.center
        
        artistLabel.center = CGPoint(x: width/2, y:height/2 + 10)
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        artistLabel.textAlignment = NSTextAlignment.center
        
        addSubview(artistLabel)
        addSubview(titleLabel)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        artistLabel.text = "-"
        titleLabel.text = "-"
    }
    
    func setPlayButton(playing: Bool){
        if playing == true {
            button.setImage(UIImage.init(named: "pause"), for: .normal)
        } else {
            button.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    // MARK: Button Action
    func togglePlay(button: UIButton) {
        let playing = !AudioManager.sharedInstance().isPlaying
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
