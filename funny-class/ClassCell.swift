//
//  ClassCell.swift
//  funny-class
//
//  Created by vzyw on 12/17/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    @IBOutlet weak var classStart: UILabel!
    @IBOutlet weak var classEnd: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classAt: UILabel!
    @IBOutlet weak var classTime: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var unread: ReadPoint!
    
    var courseInfo:Dictionary<String,Any>?
    var classInfo:Dictionary<String,Any>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let padding = CGFloat(3)
        unread.contentInset = UIEdgeInsets(top: padding, left: 6, bottom: padding, right: 6)
        unread.layer.cornerRadius = (unread.layer.frame.size.height + padding * 2) / 2
        unread.layer.masksToBounds = true
        // Initialization code
    }
    
    func setNum(num:Int){
        if(num == 0) {
            unread.isHidden = true
            return
        }
        unread.text = String(num)
        unread.isHidden = false
    }
    
    func initView(){
        let info = classInfo!
        let start = info["sksd_jc_s"] as! Int
        let end = info["sksd_jc_e"] as! Int
        setTime(start: start,end: end)
        
        classStart.text = "第" + String(start) + "节"
        classEnd.text = "第" + String(end) + "节"
        classAt.text = info["cr_mc"] as? String
        className.text = courseInfo?["kc_mc"] as? String
        

        if(start == 51){
            classStart.text = "午1"
        }
        if(end == 52){
            classEnd.text = "午2"
        }
    }
    
    private func setTime(start:Int, end:Int){
        classTime.text = startTime(start: start) + "-" + endTime(end: end)
    }
    private func startTime(start:Int) -> String{
        switch start {
        case 1:
            return "8:00"
        case 2:
            return "8:55"
        case 3:
            return "10:00"
        case 4:
            return "10:55"
        case 51:
            return "12:30"
        case 52:
            return "13:25"
        case 5:
            return "14:30"
        case 6:
            return "15:25"
        case 7:
            return "16:30"
        case 8:
            return "17:25"
        case 9:
            return "19:30"
        case 10:
            return "20:25"
        default:
            return ""
        }
    }
    private func endTime(end:Int) -> String{
        switch end {
        case 1:
            return "8:45"
        case 2:
            return "9:40"
        case 3:
            return "10:45"
        case 4:
            return "11:45"
        case 51:
            return "13:15"
        case 52:
            return "12:10"
        case 5:
            return "15:15"
        case 6:
            return "16:10"
        case 7:
            return "17:15"
        case 8:
            return "18:10"
        case 9:
            return "20:15"
        case 10:
            return "21:10"
        default:
            return ""
        }
    }
    
    
}
