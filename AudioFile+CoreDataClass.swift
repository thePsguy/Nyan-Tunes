//
//  AudioFile+CoreDataClass.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 27/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import CoreData


public class AudioFile: NSManagedObject {

    convenience init(id: Int, title: String, artist:String, url: String, audioData: Data, duration: String, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "AudioFile", in: context){
            self.init(entity: ent, insertInto: context)
            self.id = Int32(id)
            self.title = title
            self.artist = artist
            self.url = url
            self.audioData = audioData as NSData
            self.duration = duration
        }else{
            fatalError("ENTITY NOT FOUND")
        }
    }
}
