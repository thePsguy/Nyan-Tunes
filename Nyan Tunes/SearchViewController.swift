//
//  SearchViewController.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 27/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import VKSdkFramework

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var miniPlayer: MiniPlayerView!
    
    var audioManager = AudioManager.sharedInstance
    let vkManager = VKClient.sharedInstance()
    
    var searchItems = [VKAudio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        miniPlayer.delegate = self
        audioTableView.dataSource = self
        audioTableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        miniPlayer.refreshStatus()
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let params = ["q": searchText, "auto_complete": "1", "sort": "2", "search_own": "1"]
        vkManager.getSearchResults(withParams: params) { (error, resultItems) in
            if error != nil {
                print(error)
            }else{
                self.searchItems = resultItems!
                self.audioTableView.reloadData()
            }
        }
        self.audioTableView.reloadData()
    }

}

extension SearchViewController: MiniPlayerViewDelegate{
    func togglePlay() {
        if audioManager.isPlaying {
            audioManager.pausePlay()
        }else{
            audioManager.resumePlay()
        }
        miniPlayer.refreshStatus()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioTableViewCell
        let audioItem = self.searchItems[indexPath.row]
        cell.title.text = audioItem.title
        cell.artist.text = audioItem.artist
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        
        let download = UITableViewRowAction(style: .default, title: "Add to Profile") { (action, actionIndex) in
            self.rowActionHandler(action: action, indexPath: indexPath)
        }
        download.backgroundColor = UIColor.green
        actions.append(download)
        
        return actions
    }
    
    func rowActionHandler(action: UITableViewRowAction, indexPath: IndexPath) {
        if action.title == "Add to Profile" {
            let audioItem = searchItems[indexPath.row]
            vkManager.addUserAudio(audioID: audioItem.id.stringValue, owner_id: audioItem.owner_id.stringValue, completion: { (error, res) in
                if error != nil {
                    print(error)
                }else{
                    print("RESPONSE:", res)
                }
            })
        }
        audioTableView.setEditing(false, animated: true)
    }

    
}
