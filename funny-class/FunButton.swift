//
//  FunButton.swift
//  funny-class
//
//  Created by vzyw on 12/19/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class FunButton: UIButton {
    
    init(frame: CGRect,name:String,title:String) {
        
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1).cgColor
        
        let icon = UIImageView(image: UIImage(named:name))
        icon.frame.origin.y = 22
        icon.center.x = self.frame.size.width/2
        self.addSubview(icon)
        
        let text = UILabel(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: 30))
        text.frame.origin.y = 53
        text.text = title
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 14)
        text.adjustsFontSizeToFitWidth = true
        text.textColor = UIColor(red:0.62, green:0.62, blue:0.65, alpha:1)
        self.addSubview(text)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    

}
