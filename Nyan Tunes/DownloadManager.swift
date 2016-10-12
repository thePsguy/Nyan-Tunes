//
//  DownloadManager.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 27/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VK_ios_sdk

class DownloadManager:NSObject {

    var activeDownloads = [String: Download]()
    var audioManager = AudioManager.sharedInstance
    
    static let sharedInstance = DownloadManager()
    
    var downloadDelegate: URLSessionDownloadDelegate?
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration, delegate: {return self.downloadDelegate}(), delegateQueue: nil) // Must set delegate manually
        return session
    }()
}

protocol DownloadManagerDelegate: class {
    func didWriteBytes()
    func didFinishDownload()
}
