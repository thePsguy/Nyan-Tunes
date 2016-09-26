//
//  MyMusicViewController.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 26/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import VKSdkFramework
import AVFoundation

class MyMusicViewController: UIViewController {

    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var miniPlayer: MiniPlayerView!
    var activeDownloads = [String: Download]()
    
    let vkManager: VKClient = {
        return VKClient.sharedInstance()
    }()
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    var audioItems:[VKAudio] = []
    var audioManager = AudioManager.sharedInstance()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miniPlayer.delegate = self
        refreshAudio()
        audioTableView.delegate = self
        audioTableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshAudio), for: UIControlEvents.valueChanged)
        audioTableView.addSubview(refreshControl)
        
    }

    @IBAction func refreshAudio(){
        vkManager.getUserAudio(completion: {error, audioItems in
            if error != nil {
                print(error)
            }else{
                self.audioItems = audioItems!
                self.audioTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MyMusicViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioTableViewCell
        let audioItem = audioItems[indexPath.row]
        
        if(audioItem.url != nil){
            var showDownloadControls = false
            if let download = activeDownloads[audioItem.url!] {
                showDownloadControls = true
                cell.progressView.progress = download.progress
                cell.progressLabel.text = "Downloading..."
            }
            
            cell.cancelButton.isHidden = !showDownloadControls
            cell.cancelButton.isEnabled = showDownloadControls
            cell.downloadButton.isHidden = showDownloadControls
            cell.progressView.isHidden = !showDownloadControls
            cell.progressLabel.isHidden = !showDownloadControls
        }
        
        cell.trackDelegate = self
        cell.title.text = audioItem.title!
        cell.artist.text = audioItem.artist!
        cell.url = URL(string: audioItem.url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        
        let download = UITableViewRowAction(style: .default, title: "Delete") { (action, actionIndex) in
            self.rowActionHandler(action: action, indexPath: indexPath)
        }
        
        actions.append(download)
        
        return actions
    }
    
    func rowActionHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        if action.title == "Delete" {
            vkManager.deleteUserAudio(audioID: audioItems[indexPath.row].id.stringValue, completion: { (error, res) in
                if error != nil {
                    print(error)
                }else{
                    print("RESPONSE:", res)
                    self.refreshAudio()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AudioTableViewCell
        miniPlayer.artistLabel.text = cell.artist.text
        miniPlayer.titleLabel.text = cell.title.text
        miniPlayer.setPlayButton(playing: true)
        audioManager.playNow(obj: audioItems[indexPath.row])
    }
    
    
}

extension MyMusicViewController: MiniPlayerViewDelegate{
    func togglePlay() {
        if audioManager.isPlaying {
            audioManager.pausePlay()
        }else{
            audioManager.resumePlay()
        }
    }

}


extension MyMusicViewController: AudioTableViewCellDelegate{
    
    func downloadTapped(onCell: AudioTableViewCell) {
        print("Download Tapped")
        
        if let indexPath = audioTableView.indexPath(for: onCell) {
            print("at", indexPath.row)
            let track = audioItems[indexPath.row]
            startDownload(track: track)
            audioTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
        
    }
    
    func cancelTapped(onCell: AudioTableViewCell) {
        if let indexPath = audioTableView.indexPath(for: onCell) {
            let track = audioItems[indexPath.row]
            print(track)
            cancelDownload(track: track)
            audioTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
}

extension MyMusicViewController: URLSessionDownloadDelegate{
  
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

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(location)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
                // 1
                if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
                    let download = activeDownloads[downloadUrl] {
                    // 2
                    download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
                    // 3
                    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
                    // 4
                    let trackIndex = trackIndexForDownloadTask(downloadTask: downloadTask)
                    if (trackIndex != nil){
                        let audioCell = audioTableView.cellForRow(at: IndexPath(row: trackIndex!, section: 0)) as? AudioTableViewCell
                        DispatchQueue.main.async {
                            audioCell!.progressView.progress = download.progress
                            audioCell!.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
                        }
                    }
                }
        
    }
    
    
//    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        
//        // 1
//        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
//            let download = activeDownloads[downloadUrl] {
//            // 2
//            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
//            // 3
//            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
//            // 4
//            let trackIndex = trackIndexForDownloadTask(downloadTask: downloadTask)
//            if (trackIndex != nil){
//                let audioCell = audioTableView.cellForRow(at: IndexPath(row: trackIndex!, section: 0)) as? AudioTableViewCell
//                DispatchQueue.main.async {
//                    audioCell!.progressView.progress = download.progress
//                    audioCell!.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
//                }
//            }
//        }
//    }
    
    func trackIndexForDownloadTask(downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in audioItems.enumerated() {
                if url == track.url! {
                    return index
                }
            }
        }
        return nil
    }


}

