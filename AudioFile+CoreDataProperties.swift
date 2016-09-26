//
//  AudioFile+CoreDataProperties.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 27/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import CoreData


extension AudioFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioFile> {
        return NSFetchRequest<AudioFile>(entityName: "AudioFile");
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var artist: String?
    @NSManaged public var audioData: NSData?

}
