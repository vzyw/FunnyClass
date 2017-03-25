//
//  Course.swift
//  funny-class
//
//  Created by vzyw on 12/20/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
import Alamofire

class Course: NSObject {
    static let socket = SocketMannage.shareInstance()

    let DAY = ["周一","周二","周三","周四","周五"]
    
    var data:Array<Any>!
    var coursesPerDay:Array< Array<Any> > = [[],[],[],[],[]]
    var notRead:Dictionary<Int,Int> = [:]
    
    func getCourse(termId:String,callback:@escaping (Bool,String) -> Void){
        Alamofire.request(Configs.coursesURL + "?termid=" + termId).responseJSON { (response) in
            switch response.result{
            case .success:
                let dic = response.result.value as! Dictionary<String,Any>
                if(dic["code"] as! Int == 0){
                    self.data = dic["data"] as! Array<Any>
                    self.sortClass()
                    callback(true,dic["msg"] as! String)
                }else{
                    callback(false,dic["msg"] as! String)
                }
            case .failure:
                callback(false,"出错了，请稍后再试")
            }
        }
    }
    
    //分类课程
    private func sortClass(){
        
        for i in 0...data.count-1{
            let dic = data[i] as! Dictionary<String,Any>
            let arr = dic["kcb_sksd"] as? Array<Any>
            if(arr == nil){continue}
            for course in arr!{
                addCourse(course: course as! Dictionary<String, Any>)
            }
        }
    }
    
    private func addCourse(course:Dictionary<String,Any>){
        for i in 0...DAY.count-1{
            if(course["sksd_xq"] as! String == DAY[i]){
                coursesPerDay[i].append(course)
            }
        }
    }
    //分类课程-end
    
    
    //获取课程 day从0开始
    func getCourses(byWeek:Int, andDay:Int) -> Array<Any>{
        var arr:Array<Any> = [];
        let flag = byWeek % 2 //双周则为0 单周则为1
        let course = coursesPerDay[andDay] as! Array<Dictionary<String, Any>>
        for course in course{
            if(course["sksd_zc"] as! String == "双周"){
                if(flag != 0){ continue }
            }else if (course["sksd_zc"] as! String == "单周"){
                if(flag == 0){ continue }
            }
            
            if(byWeek < course["sksd_qzz_s"] as! Int || byWeek >  course["sksd_qzz_e"] as! Int){
                continue
            }
            arr.append(course)
        }
        
        arr.sort { (s1, s2) -> Bool in
            let _s1 = s1 as! Dictionary<String,Any>
            let _s2 = s2 as! Dictionary<String,Any>
            var e1 = _s1["sksd_jc_e"] as! Double
            var e2 = _s2["sksd_jc_e"] as! Double
            
            if(e1 == 51 || e1 == 52 ){e1 = 4.1}
            if(e2 == 51 || e2 == 52 ){e2 = 4.1}
            return e1 < e2
        }
        return arr
    }
    
    func getCourse(byID:Int) -> Dictionary<String,Any>?{
        for item in data{
            let dic = item as! Dictionary<String,Any>
            if(dic["kcb_id"] as! Int == byID){
                return dic
            }
        }
        return nil
    }
    
    func getNotRead(byId:Int,callback:@escaping (Int)->()){
//        if let _notRead = notRead[byId]{
//            return callback(_notRead)
//        }
        let db = News()
        let last = db.lastTimeStamp(roomId: byId)
        Course.socket.connect()
        DispatchQueue.global(qos:.utility).async {
            while !Course.socket.logined{}
            print("socket logined")
            Course.socket.getMessages(roomId: byId, timeStamp: last, callback: { (flag, arr) in
                if(flag){
                    callback(arr.count)
                    self.notRead[byId] = arr.count
                    db.storeNews(roomId: byId, news: arr)
                }
            })
        }
    }

}
