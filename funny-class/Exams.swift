//
//  Exams.swift
//  funny-class
//
//  Created by vzyw on 12/29/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
import Alamofire

class Exams: NSObject {
    let data:Dictionary<String,Any> = [:]
    
    static func examsData(callback:@escaping (Bool,[Dictionary<String,Any>]?)->()){
        Alamofire.request(Configs.examsURL).responseJSON { responser in
            switch responser.result{
            case .success:
                let dir  = responser.result.value as? Dictionary<String,Any>
                callback(true,dir?["data"] as? [Dictionary<String,Any>])
            case .failure:
                callback(false,nil)
            }
        }
    }
}
