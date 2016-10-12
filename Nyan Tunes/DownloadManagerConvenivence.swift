//
//  DownloadManagerConvenivence.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 27/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VK_ios_sdk

extension DownloadManager {

    func startDownload(track: VKAudio) {
        if let urlString = track.url, let url =  NSURL(string: urlString) {
            let fileID: String = track.id.stringValue;
            // 1
            let download = Download(url: urlString, fileID: fileID)
            // 2
            download.downloadTask = downloadsSession.downloadTask(with: url as URL)
            // 3
            download.downloadTask!.resume()
            // 4
            download.isDownloading = true
            // 5
            activeDownloads[download.url] = download
        }
    }
    
    func cancelDownload(track: VKAudio) {
        if let urlString = track.url,
            let download = activeDownloads[urlString] {
            download.downloadTask?.cancel()
            activeDownloads[urlString] = nil
        }
    }
    
    func trackIndexForDownloadTask(downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in audioManager.profileAudioItems.enumerated() {
                if url == track.url! {
                    return index
                }
            }
        }
        return nil
    }

}
