//
//  MessageCell.swift
//  funny-class
//
//  Created by vzyw on 12/24/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var message: ReadPoint!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var anonLabel: ReadPoint!
    
    @IBOutlet weak var meHeadImg: UIImageView!
    @IBOutlet weak var meUsernameLabel: UILabel!
    @IBOutlet weak var meMessage: ReadPoint!
    
    var used = false
    
    static let name = UserDefaults.standard.value(forKey: "name") as! String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initView(headImg,headImg.frame.size.height/2)
        initView(anonLabel,1.5)
        initView(meHeadImg, meHeadImg.frame.size.height/2)
        initView(message,5)
        initView(meMessage,5)

    }
    
    
    private func initView(_ view:UIView,_ cornerRadius:CGFloat){
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    private func hidden(){
        let arr = [message,headImg,usernameLabel,meHeadImg,meUsernameLabel,meMessage] as [Any]
        for item in arr{
            let view = item as! UIView
            view.isHidden = !view.isHidden
        }
    }
    
    private func initData(){
        message.isHidden = false
        headImg.isHidden = false
        usernameLabel.isHidden = false
        anonLabel.isHidden = true
        
        meMessage.isHidden = true
        meHeadImg.isHidden = true
        meUsernameLabel.isHidden = true

    }
    
    func setData(data:Dictionary<String,Any>){
        initData()
        if(data["nicked"] as! Int == 1){
            anonLabel.isHidden = false
        }else{
            anonLabel.isHidden = true
        }
        
        if(data["name"] as! String == MessageCell.name){
            hidden()
            meMessage.text = data["msg"] as? String
            meUsernameLabel.text = (data["name"] as? String)?.uppercased()
        }else{
            message.text = data["msg"] as? String
            usernameLabel.text = (data["name"] as? String)?.uppercased()
        }
    }
}
