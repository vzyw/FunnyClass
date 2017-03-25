//
//  Login.swift
//  funny-class
//
//  Created by vzyw on 12/19/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
import Alamofire

class Login: NSObject {
    
    static func login(postData:Parameters,callback:@escaping (DataResponse<Any>)->()){
        Alamofire.request(Configs.loginURL, method: .post, parameters: postData, encoding: JSONEncoding.default).responseJSON {response in
            callback(response)
        }
    }
    
    static func getImgCode(callback:@escaping (DataResponse<Data>)->()){
        Alamofire.request(Configs.loginURL).responseData {response in
            callback(response)
        }
    }
    
    static func LoginOut(){
        Alamofire.request(Configs.loginOutURL)
    }
    
    static func showLoginView(target:UIViewController){
        let loginView = Tools.viewById(id: "LoginView")
        target.present(loginView, animated: true, completion: nil)
    }
    
    static func akiKey(callback:@escaping (String)->()){
         Alamofire.request(Configs.apikeyURL).responseJSON { data in
            switch data.result{
            case .success:
                let dic = data.result.value as! Dictionary<String,Any>
                callback(dic["data"] as! String)
            case .failure:
                callback("")
            }
        }
    }
    
}
