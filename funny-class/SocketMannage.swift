//
//  SocketMannage.swift
//  funny-class
//
//  Created by vzyw on 12/24/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
import Alamofire
import SocketIO

protocol SocketDelegate {
    func newMessage(_:  Dictionary<String,Any>)
}


class SocketMannage: NSObject {
    let socket:SocketIOClient
    var delegate:SocketDelegate? = nil
    var connected:Bool = false
    var logined:Bool = false
    
    static let instance = SocketMannage()
    
    private override init(){
        socket =
            SocketIOClient(socketURL: URL(string: Configs.socketURL)!, config: [.log(false)])
        super.init()
        self.addHandlers()
    }
    
    static func shareInstance() -> SocketMannage{
        return instance
    }
    
    
    private func addHandlers(){
        socket.on("connect"){ [weak self] data, ack in
            self?.connected = true
            self?.login(callback: { flag,msg in
                self?.logined = true
                //self?.delegate?.logined(flag, msg)
            })
        }
        
        
        socket.on("news"){[weak self] data,ack in
            self?.delegate?.newMessage(data[0] as! Dictionary<String,Any>)
        }
        
    }
    
    func connect(){
        if (socket.status == SocketIOClientStatus.notConnected){
            socket.connect()
        }
    }
    
    func login(callback:@escaping (Bool,String)->()){
        let userDefault = UserDefaults.standard
        let username = userDefault.value(forKey: "name")
        let apikey = userDefault.value(forKey: "apikey")
        print (username)
        print (apikey)
        
//        let username = "cst14090"
//        let apikey = "17cbc668016c786882d8646dcbd2457c"
//        
        
        self.socket.emitWithAck("login",["username":username,"apikey":apikey]).timingOut(after: 0, callback: { args in
            if(args[0] as! Int == 0){
                self.logined = true
                return callback(true,args[1] as! String)
            }
            callback(false,args[1] as! String)
        })
    }
    
    
    func sendMessage(data:String,nicked:Bool){
        var _nicked:Int = 0
        if(nicked){
            _nicked = 1
        }
        socket.emit("news", ["msg":data,"nicked":_nicked])
    }
    
    func joinRoom(roomId:Int,callback:@escaping (Bool,String)->()){
        socket.emitWithAck("join", ["roomId":roomId]).timingOut(after: 0) { data in
            if(data[0] as! Int == 0){
                return callback(true,data[1] as! String)
            }
            callback(false,data[1] as! String)
        }
    }
    
    func getMessages(roomId:Int,timeStamp:Int64,callback:@escaping (Bool,[Dictionary<String,Any>])->()){
        socket.emitWithAck("not-read", ["roomId":roomId,"timeStamp":timeStamp]).timingOut(after: 0) { data in
            if(data[0] as! Int == 0){
                return callback(true,data[1] as! [Dictionary<String,Any>])
            }
            callback(false,[])
        }
    }
}
