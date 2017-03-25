//
//  CoursesViewHeader.swift
//  funny-class
//
//  Created by vzyw on 12/13/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

protocol CoursesViewHeaderListener {
    func next()
    func prev()
}
class CoursesViewHeader: NSObject {
    

    var navItem:UINavigationItem?
    var titleView:UIView?
    
    var listeners:[CoursesViewHeaderListener]
    var week:Int?
    
    override init(){
        self.listeners = []
        super.init()
    }
    
    func setNavItem(navigationItem:UINavigationItem){
        self.navItem = navigationItem
        let leftButton = UIBarButtonItem(image:UIImage(named: "prev")
            , landscapeImagePhone: nil, style: .plain, target: self, action:#selector(prev(_:)))
        let rightButton = UIBarButtonItem(image: UIImage(named: "next"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(next(_:)))
        
        navItem!.leftBarButtonItem = leftButton;
        navItem!.rightBarButtonItem = rightButton;
        
        navItem!.leftBarButtonItem?.tintColor = UIColor.black
        navItem!.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    
    func setTitleView(titleView:UIView){
        self.navItem?.titleView = titleView
    }
    
    
    
    func prev(_ sender:Any){
        for observer in listeners{
            observer.prev();
        }
    }
    func next(_ sender:Any){
        for observer in listeners{
            observer.next();
        }
    }
    
    func addListener(listener:CoursesViewHeaderListener){
        listeners.append(listener)
    }
    
    
    
}
