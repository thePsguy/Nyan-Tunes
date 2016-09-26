//
//  download.swift
//  VmusiK
//
//  Created by Pushkar Sharma on 21/08/2016.
//  Copyright © 2016 Pushkar Sharma. All rights reserved.
//

import Foundation

class Download: NSObject {
    
    var fileID: String
    var url: String
    var isDownloading = false
    var progress: Float = 0.0
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: NSData?
    
    init(url: String, fileID: String) {
        self.url = url
        self.fileID = fileID
    }
}
