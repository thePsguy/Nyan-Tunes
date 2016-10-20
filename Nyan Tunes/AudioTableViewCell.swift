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

    
    var bitrateLabel: NetworkBitrateLabel!
    var durationLabel: UILabel!
    
    var url: URL?
    var audioData: Data?
    var duration: Int?
    var trackBytes: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        let width = bounds.size.width
        
        self.title.adjustsFontSizeToFitWidth = true
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        title.textColor = UIColor.white
        artist.textColor = UIColor.white
        progressLabel?.textColor = UIColor.white
        cancelButton?.tintColor = UIColor.white
        downloadButton?.tintColor = UIColor.white
        
        let nick = UIImageView.init(frame: CGRect(x: width-15, y: 5, width: 12, height: 12))
        nick.contentMode = UIViewContentMode.scaleAspectFit
        nick.image = UIImage(named: "DragLeft")
        
        bitrateLabel.frame = CGRect(x: width-45, y: 15, width: 45, height: 18)
        bitrateLabel.textColor = .white
        bitrateLabel.adjustsFontSizeToFitWidth = true
        
        durationLabel.frame = CGRect(x: width-45, y: 5, width: 45, height: 18)
        durationLabel.textColor = .white
        durationLabel.font = durationLabel.font.withSize(12)
        
        if duration != nil {
            let seconds = duration!
            let minutes = Int(seconds/60)
            durationLabel.text = "\(minutes):" + String(format: "%02d",seconds-minutes*60)
            
            if trackBytes != nil{
                let bitrate = Int((trackBytes!/1024)/seconds)   //Bytes to Kbs
                bitrateLabel.setBitrateFrom(value: bitrate)
            } else if url != nil {
                bitrateLabel.setBitrateFrom(url: url!, withTrackLength: duration!)
            }
        }
        
        self.addSubview(durationLabel)
        self.addSubview(bitrateLabel)
        self.addSubview(nick)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bitrateLabel = NetworkBitrateLabel()
        durationLabel = UILabel()
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
    
    @IBAction func playPreview(_ sender: AnyObject) {
        trackDelegate?.playPreviewTapped(onCell: self)
    }

}

protocol AudioTableViewCellDelegate {
    func cancelTapped(onCell: AudioTableViewCell)
    func downloadTapped(onCell: AudioTableViewCell)
    func playPreviewTapped(onCell: AudioTableViewCell)
}

extension AudioTableViewCellDelegate{                       
    func cancelTapped(onCell: AudioTableViewCell){}
    func downloadTapped(onCell: AudioTableViewCell){}
    func playPreviewTapped(onCell: AudioTableViewCell){}
}
