//
//  DateAndWeek.swift
//  funny-class
//
//  Created by vzyw on 12/14/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
import Alamofire

protocol DateAndWeekDelegate {
    func dateAndWeekInitDone()
}

class DateAndWeek: NSObject {
    var startDate:Date?
    var endDate:Date?
    var weeks:Int?
    var term:String!
    
    var delegate:DateAndWeekDelegate?
    
    
    init(term:String){
        self.term = term
        super.init()
        self.getInfo()
    }
    
    
    override init(){
        super.init()
        self.getTerm()
    }
    
    
    
    //获取某周的开始日期
    func dateIn(week:Int) -> Date{
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = (week-1) * 7
        let newDate = calendar.date(byAdding: dateComponents, to: startDate!, wrappingComponents: false)
        return (newDate! as NSDate).earlierDate(endDate!)
    }
    
    func currWeek() -> Int{
//        let interval = startDate?.timeIntervalSinceNow
//        let dateComponentsFormatter = DateComponentsFormatter()
//        dateComponentsFormatter.allowedUnits =  [NSCalendar.Unit.day]
//        let days:String! = dateComponentsFormatter.string(from: interval!)!
//        let rang = days.index(days.startIndex, offsetBy: days.characters.count-1)
//        
//        
//        let day = Int(days.substring(to: rang))!
//        
        let day = Tools.daysBetweenNow(date: startDate!)
        if(day > 0 ){
            return 1
        }
        if(abs(day) / 7 > weeks! ){
            return weeks!
        }
        return abs(day)/7 + 1
    }
    
    
    //获取当前学期
    private func getTerm(){
        Alamofire.request(Configs.termURL).responseJSON{response in
            switch response.result{
            case .success:
                let dic = response.result.value as! Dictionary<String,Any>
                if(dic["code"] as! Int == 0){
                    self.term = dic["data"] as! String?
                    self.getInfo()
                }
            case .failure:
                break
            }
        }
    }
    
    
    //获取学期信息
    private func getInfo(){
        Alamofire.request(Configs.infoURL).responseJSON{response in
            switch response.result{
            case .success:
                let dic = response.result.value as! Dictionary<String,Any>
                if(dic["code"] as! Int == 0){
                    let term = (dic["data"] as! Dictionary<String,Any>)[self.term] as? Dictionary<String,Any>
                    
                    if((term) != nil){
                        self.startDate = Tools.stringToDate(date:term!["start"] as! String, formart: "yyyy-MM-dd")
                        self.endDate = Tools.stringToDate(date:term!["end"] as! String, formart: "yyyy-MM-dd")
                        self.weeks = term!["weeks"] as? Int
                        self.delegate?.dateAndWeekInitDone()
                    }
                }
            case .failure:
                break
            }
        }
    }
}
