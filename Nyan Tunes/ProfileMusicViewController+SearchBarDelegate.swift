//
//  ProfileMusicViewController+SearchBarDelegate.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 21/10/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import UIKit

extension ProfileMusicViewController: UISearchBarDelegate{

    func filterTracks(forSearchText searchText: String) {
        guard searchText != "" else{
            audioManager.profileAudioItems = allAudioItems
            return
        }
        let results = allAudioItems.filter({ (file) -> Bool in
            return (file.title?.contains(searchText))! || (file.artist?.contains(searchText))!
        })
        audioManager.profileAudioItems = results
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTracks(forSearchText: searchText)
        audioTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterTracks(forSearchText: "")
        audioTableView.reloadData()
    }

}
