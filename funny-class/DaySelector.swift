//
//  DaySelector.swift
//  funny-class
//
//  Created by vzyw on 12/15/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

protocol DaySelectorDelegate {
    func daySelected(day:Int)
}

class DaySelector: UIView {
    
    private var days:[UIButton]!
    private var dateLabels:[UILabel]!
    private let dayText:[String] = ["周一","周二","周三","周四","周五"]
    
    
    private var bottomView:UIView?
    
    var delegate:DaySelectorDelegate?

    override init(frame: CGRect){
        days = []
        dateLabels = []
        super.init(frame: frame)
        self.backgroundColor = Tools.headerColor()
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initView(){
        let width = ( Int(Tools.deviceWidth())  - 50 )  / dayText.count
        let height = Int(self.frame.size.height)
        
        bottomView = UIView(frame: CGRect(x: 0, y: height - 3, width: width, height: 3))
        bottomView?.backgroundColor = UIColor(red:0.76, green:0.22, blue:0.18, alpha:1)
        
        
        var frame = CGRect(x: 50, y: 0, width: width, height: height)
        for i in 0...dayText.count-1 {
            let textFrame = CGRect(x: 0, y: 8, width: width, height: 13)
            let dateFream = CGRect(x: 0, y: 24, width: width, height: 11)
            let textLabel = initTextLabel(frame: textFrame, text: dayText[i], fontSize: 12)
            
            let dateLabel = initTextLabel(frame: dateFream, text:"", fontSize: 9)
            
            
            let button = UIButton(frame: frame)
            button.addTarget(self, action: #selector(self.press(sender:)), for: UIControlEvents.touchUpInside)
            button.addSubview(textLabel)
            button.addSubview(dateLabel)
            button.tag = i
            days.append(button)
            dateLabels.append(dateLabel)
            self.addSubview(button)
            frame.origin.x += CGFloat(width)
        }

    }
    
    func setDateLabels(startDate:Date){
        var date = startDate
        var dates:Array<Date> = []
        for _ in 0...dayText.count-1{
            dates.append(date)
            date = Tools.add(day: 1, toDate: date)
        }
        
        for i in 0...dateLabels.count-1 {
            let dateStr = Tools.dateToString(date: dates[i], format: "MM-dd")
            dateLabels[i].text = dateStr
        }
    }
    
    private func initTextLabel(frame:CGRect,text:String,fontSize:CGFloat) -> UILabel{
        let textLabel = UILabel(frame: frame)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.font = UIFont(name: "Helvetica", size: fontSize)
        textLabel.text = text
        return textLabel
    }
    
    func press(sender:UIButton){
        bottomView!.removeFromSuperview()
        for button in days{
            button.backgroundColor = Tools.headerColor()
        }
        sender.backgroundColor = UIColor(red:0.84, green:0.84, blue:0.89, alpha:1)
        
        sender.addSubview(bottomView!)
        delegate?.daySelected(day: sender.tag)
    }
    
    func press(day:Int){
        if(day > days.count - 1){
            self.press(sender: days[days.count - 1])
        }else{
            self.press(sender: days[day])
        }
    }

}
