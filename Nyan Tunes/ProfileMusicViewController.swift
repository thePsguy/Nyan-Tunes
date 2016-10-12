//
//  MyMusicViewController.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 26/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import VK_ios_sdk
import AVFoundation
import CoreData

class ProfileMusicViewController: UIViewController {

    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var miniPlayer: MiniPlayerView!
    
    let vkManager: VKClient = {
        return VKClient.sharedInstance
    }()
    
    var files = [AudioFile]()
    var audioManager = AudioManager.sharedInstance
    let refreshControl = UIRefreshControl()
    
    // Core Data
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    var downloadManager:DownloadManager = {
        return DownloadManager.sharedInstance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadManager.downloadDelegate = self
        
        miniPlayer.delegate = self
        audioTableView.delegate = self
        audioTableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshAudio), for: UIControlEvents.valueChanged)
        audioTableView.addSubview(refreshControl)
        
        miniPlayer.makeTranslucent()
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let parent = self.parent as! ProfileViewController
        let tabBarHeight = self.tabBarController?.tabBar.frame.height == nil ? 0 : (self.tabBarController?.tabBar.frame.height)!
        let topInset = (parent.navigationController?.navigationBar.frame.height)! + parent.profileView.frame.height + UIApplication.shared.statusBarFrame.height
        let bottomInset = self.miniPlayer.frame.height + tabBarHeight
        self.audioTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        miniPlayer.refreshStatus()
        refreshAudio()
    }

    @IBAction func refreshAudio(){
        files = fetchAllAudio()
        vkManager.getUserAudio(completion: {error, audioItems in
            if error != nil {
                self.refreshControl.endRefreshing()
                DispatchQueue.main.async {
                    self.showAlert(text: error!)
                }
            }else{
                self.audioManager.profileAudioItems = audioItems!
                self.audioTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
        
    func fetchAllAudio() -> [AudioFile] {
        var result = [AudioFile]()
        sharedContext.performAndWait {
            let fetchRequest: NSFetchRequest<AudioFile> = AudioFile.fetchRequest()
            do {
                result = try self.sharedContext.fetch(fetchRequest)
            } catch {
                print("error in fetch")
            }
        }
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ProfileMusicViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioManager.profileAudioItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioTableViewCell
        let audioItem = audioManager.profileAudioItems[indexPath.row]
        if(audioItem.url != nil){
            var showDownloadControls = false
            var downloadable = true
            
            for file in files{
                if Int(audioItem.id) == Int(file.id){
                    print(audioItem.title, file.title!)
                    downloadable = false
                    cell.audioData = file.audioData! as Data
                }
            }
            if downloadable == true{
                cell.audioData = nil
            }
            
            if let download = downloadManager.activeDownloads[audioItem.url!] {
                showDownloadControls = true
                cell.progressView.progress = download.progress
                cell.progressLabel.text = "Waiting..."
            }
            
            cell.cancelButton.isHidden = !showDownloadControls
            cell.cancelButton.isEnabled = showDownloadControls
            cell.downloadButton.isHidden = !downloadable || showDownloadControls
            cell.progressView.isHidden = !showDownloadControls
            cell.progressLabel.isHidden = !showDownloadControls
        }
        
        cell.trackDelegate = self
        cell.title.text = audioItem.title!
        cell.artist.text = audioItem.artist!
        cell.duration = audioItem.duration.stringValue
        cell.url = URL(string: audioItem.url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        
        let download = UITableViewRowAction(style: .default, title: "Remove") { (action, actionIndex) in
            self.rowActionHandler(action: action, indexPath: indexPath)
        }
        
        actions.append(download)
        
        return actions
    }
    
    func rowActionHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        if action.title == "Remove" {
            vkManager.deleteUserAudio(audioID: audioManager.profileAudioItems[indexPath.row].id.stringValue, completion: { (error, res) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlert(text: error!)
                    }
                }else{
                    print("RESPONSE:", res)
                    self.refreshAudio()
                }
            })
        }
        audioTableView.setEditing(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AudioTableViewCell
        print(cell.title.text, cell.audioData)
        audioManager.playNow(obj: cell)
        miniPlayer.refreshStatus()
    }
}

extension ProfileMusicViewController: MiniPlayerViewDelegate{
    func togglePlay() {
        if audioManager.isPlaying {
            audioManager.pausePlay()
        }else{
            audioManager.resumePlay()
        }
        miniPlayer.refreshStatus()
    }
}

extension ProfileMusicViewController: URLSessionDownloadDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil{
            let trackIndex = downloadManager.trackIndexForDownloadTask(downloadTask: task as! URLSessionDownloadTask)
            if (trackIndex != nil){
                let audioCell = audioTableView.cellForRow(at: IndexPath(row: trackIndex!, section: 0)) as? AudioTableViewCell
                DispatchQueue.main.async {
                    audioCell!.progressLabel.text =  "Network Error."
                    if error?.localizedDescription != "cancelled"{
                        self.showAlert(text: (error?.localizedDescription)!)
                    }
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        showAlert(text: (error?.localizedDescription)!)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // 1
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = downloadManager.activeDownloads[downloadUrl] {
            // 2
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            // 3
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            // 4
            
            if let trackIndex = downloadManager.trackIndexForDownloadTask(downloadTask: downloadTask){
                if let audioCell = audioTableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? AudioTableViewCell {
                    DispatchQueue.main.async {
                        audioCell.progressView.progress = download.progress
                        audioCell.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
                    }
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            let trackIndex = downloadManager.trackIndexForDownloadTask(downloadTask: downloadTask)
            if (trackIndex != nil){
                let track = audioManager.profileAudioItems[trackIndex!]
                let _ = AudioFile(id: track.id as Int, title: track.title, artist: track.artist, url: track.url, audioData: try! Data.init(contentsOf: location), duration: track.duration.stringValue, context: sharedContext)
                do{
                    try sharedContext.save()
                } catch { print("CoreData save error") }
                
                DispatchQueue.main.async {
                    let taskUrl = downloadTask.originalRequest?.url?.absoluteString
                    self.downloadManager.activeDownloads[taskUrl!] = nil
                    self.files = self.fetchAllAudio()
                    self.audioTableView.reloadRows(at: [IndexPath(row: trackIndex!, section: 0)], with: .none)
                }
            }else{
                DispatchQueue.main.async {
                    let taskUrl = downloadTask.originalRequest?.url?.absoluteString
                    self.downloadManager.activeDownloads[taskUrl!] = nil
                    self.files = self.fetchAllAudio()
                    self.audioTableView.reloadData()
                }
            }
    }
}


extension ProfileMusicViewController: AudioTableViewCellDelegate{
    
    func downloadTapped(onCell: AudioTableViewCell) {
        if let indexPath = audioTableView.indexPath(for: onCell) {
            let track = audioManager.profileAudioItems[indexPath.row]
            downloadManager.startDownload(track: track)
            audioTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    func cancelTapped(onCell: AudioTableViewCell) {
        if let indexPath = audioTableView.indexPath(for: onCell) {
            let track = audioManager.profileAudioItems[indexPath.row]
            downloadManager.cancelDownload(track: track)
            audioTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
}
