//
//  Tools.swift
//  funny-class
//
//  Created by vzyw on 12/13/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class Tools: NSObject {
    static func drawImageFromColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.set()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func viewById( id:String) -> UIViewController{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let view = storyBoard.instantiateViewController(withIdentifier: id);
        return view;
    }
    
    static func deviceWidth() -> CGFloat{
        return UIScreen.main.bounds.size.width;
    }
    static func deviceHeight() -> CGFloat{
        return UIScreen.main.bounds.size.height;
    }
    
    static func loadViewFromNib(_class:UIView) ->UIView{
        let bundle = Bundle(for:  type(of:_class))
        let nib = UINib(nibName: String(describing: type(of:_class)), bundle: bundle)
        let view = nib.instantiate(withOwner: _class, options: nil)[0] as! UIView
        return view
    }
    
    
    static func headerColor() -> UIColor{
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    }
    
//    static func alert(title:String,msg:String) -> UIAlertController{
//        
//    }
    
    static func stringToDate(date:String,formart:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formart
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: date)!
    }
    
    static func dateToString(date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func add(day:Int ,toDate:Date)->Date{
        let calendar = Calendar.current
        var newDateComponents = DateComponents()
        newDateComponents.day = day
        return calendar.date(byAdding: newDateComponents, to: toDate, wrappingComponents: false)!
    }
    
    static func daysBetweenNow(date:Date) -> Int{
        let interval = date.timeIntervalSinceNow
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits =  [NSCalendar.Unit.day]
        let days:String! = dateComponentsFormatter.string(from: interval)!
        let rang = days.index(days.startIndex, offsetBy: days.characters.count-1)
        let day = Int(days.substring(to: rang))!
        return day
    }
    //return  0 星期一，1 星期二
    static func dayToInt(day:Date) -> Int{
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.weekday], from: day)
        var day = comps.weekday!-2
        if(day < 0){
            day = 0
        }
        return day
    }

}
