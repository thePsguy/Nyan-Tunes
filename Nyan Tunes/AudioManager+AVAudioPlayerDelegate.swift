//
//  AudioManager+AVAudioPlayerDelegate.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 21/10/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import AVFoundation

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playNext()
    }
}
