//
//  VKConvenience.swift
//  Nyan Tunes
//
//  Created by Pushkar Sharma on 26/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import VKSdkFramework

extension VKClient {

    func setUser(user: VKUser){
        self.User = user
    }
    
    func getUser() -> VKUser? {
        return self.User
    }
    
    func sessionExistsWith(_ SCOPE: [Any], completion: @escaping (Bool) -> Void){
        VKSdk.wakeUpSession(SCOPE, complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            if (state == VKAuthorizationState.authorized) {
                self.User = VKSdk.accessToken().localUser
                completion(true)
            }
            else if (error != nil) {
                print("Error:",error)
                completion(false)
            }else{
                completion(false)
            }
        })
    }
    func authorize(_ SCOPE: [Any]){
//        VKSdk.authorize(SCOPE)
        VKSdk.authorize(SCOPE, with: VKAuthorizationOptions.unlimitedToken)
        
    }

    func getUserAudio(completion: @escaping (String?, [VKAudio]?) -> Void){
        let audioReq: VKRequest = VKRequest.init(method: "audio.get", parameters: nil, modelClass: VKAudios.self) //VKRequest(method: "audio.get", andParameters: nil, andHttpMethod: "GET", classOfModel: VKAudios.self)
        audioReq.execute(resultBlock: { (audioRes) in
            let userAudios: VKAudios?  = audioRes?.parsedModel as? VKAudios
            var audioItems: [VKAudio] = []
            for item in userAudios!.items{
                audioItems.append(item as! VKAudio)
            }
            completion(nil, audioItems)
        }) { (error) in
            if(error != nil){
                completion(error?.localizedDescription, nil)
            }
        }
    }
    
    func getSearchResults(withParams params: [String: String], completion: @escaping (String?, [VKAudio]?) -> Void){
    
        let audioReq: VKRequest = VKRequest.init(method: "audio.search", parameters: params, modelClass: VKAudios.self) //(method: "audio.search", andParameters: params, andHttpMethod: "GET", classOfModel: VKAudios.self)
        audioReq.execute(resultBlock: { (audioRes) in
    
            let result: VKAudios?  = audioRes?.parsedModel as? VKAudios
            // print("userAudios:", userAudios, audioRes.json)
            let resultAudios = result?.items as! [VKAudio]
            completion(nil, resultAudios)
        }) { (error) in
            completion(error?.localizedDescription, nil)
        }
    }
    
    func deleteUserAudio(audioID: String, completion: @escaping (String?, Bool?) -> Void){
        let params = ["audio_id": audioID, "owner_id":  self.User!.id] as [String : Any]
        let audioReq: VKRequest = VKRequest.init(method: "audio.delete", parameters: params, modelClass: VKAudios.self) //VKRequest(method: "audio.get", andParameters: nil, andHttpMethod: "GET", classOfModel: VKAudios.self)
        audioReq.execute(resultBlock: { (response) in
            completion(nil, true)
        }) { (error) in
            if(error != nil){
                completion(error?.localizedDescription, nil)
            }
        }
    }

    func addUserAudio(audioID: String, owner_id: String, completion: @escaping (String?, Bool?) -> Void){
        let params = ["audio_id": audioID, "owner_id":  owner_id] as [String : Any]
        let audioReq: VKRequest = VKRequest.init(method: "audio.add", parameters: params, modelClass: VKAudios.self) //VKRequest(method: "audio.get", andParameters: nil, andHttpMethod: "GET", classOfModel: VKAudios.self)
        audioReq.execute(resultBlock: { (response) in
            completion(nil, true)
        }) { (error) in
            if(error != nil){
                completion(error?.localizedDescription, nil)
            }
        }
    }

}
