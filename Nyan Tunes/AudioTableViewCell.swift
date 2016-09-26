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
    
    var url: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
