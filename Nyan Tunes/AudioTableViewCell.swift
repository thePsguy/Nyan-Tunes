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
    
    
    var url: URL?
    var audioData: Data?
    var duration: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        let width = bounds.size.width
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        title.textColor = UIColor.white
        artist.textColor = UIColor.white
        progressLabel?.textColor = UIColor.white
        cancelButton?.tintColor = UIColor.white
        downloadButton?.tintColor = UIColor.white
        
        let nick = UIImageView.init(frame: CGRect(x: width-15, y: 5, width: 12, height: 12))
        nick.contentMode = UIViewContentMode.scaleAspectFit
        nick.image = UIImage(named: "DragLeft")
        
        self.addSubview(nick)
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
