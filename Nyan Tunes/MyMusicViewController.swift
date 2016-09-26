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
    
    let vkManager: VKClient = {
        return VKClient.sharedInstance()
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
