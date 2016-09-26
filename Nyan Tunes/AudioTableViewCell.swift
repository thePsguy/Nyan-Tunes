//
//  AudioTableViewCell.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 26/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumArt: NetworkImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    var trackDelegate: AudioTableViewCellDelegate?
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    
    var url: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        trackDelegate?.cancelTapped(onCell: self)
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
        trackDelegate?.downloadTapped(onCell: self)
    }

}

protocol AudioTableViewCellDelegate {
    func cancelTapped(onCell: AudioTableViewCell)
    func downloadTapped(onCell: AudioTableViewCell)
}
