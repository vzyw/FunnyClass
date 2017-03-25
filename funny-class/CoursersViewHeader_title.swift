//
//  CoursersViewHeader_title.swift
//  funny-class
//
//  Created by vzyw on 12/14/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
protocol CoursersViewHeader_titleDelegate {
    func pressbackButton()
}

class CoursersViewHeader_title: UIView{

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    
    weak var view:UIView!
    
    var week:Int?
    var date:Date?
    
    var delegate:CoursersViewHeader_titleDelegate?

    
    func setupSubviews() {
        view = Tools.loadViewFromNib(_class: self)
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    override func layoutSubviews() {
        view.frame = bounds
    }
    
    

    override init(frame:CGRect){
        super.init(frame: frame)
        setupSubviews()
    }
   
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.delegate?.pressbackButton()
    }
    
    func setDate(_ date:Date, andWeek:Int){
        self.date = date
        self.week = andWeek
        updateLabels()
    }
    
    func updateLabels(){
        weekLabel.text = "第" + String(week!) + "周"
        dateLable.text = Tools.dateToString(date: date!, format: "yyyy年MM月")
    }
}
