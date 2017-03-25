//
//  ExamCell.swift
//  funny-class
//
//  Created by vzyw on 12/29/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class ExamCell: UITableViewCell {
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var when: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dateBg: UIView!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:Dictionary<String,Any>){
        name.text = data["kc_mc"] as? String
        location.text = "@" + (data["cr_mc"] as? String)!
        when.text = (data["ksap_kssd"] as! String ) + " " + (data["ksap_kssj"] as! String)
    
        let _date = Tools.stringToDate(date: data["ksap_ksrq"] as! String, formart:"yyyy-MM-dd")
        let dateStr = Tools.dateToString(date: _date, format: "MM月dd日")
        date.text  = dateStr
        
        dateBg.backgroundColor = UIColor(red:0.21, green:0.49, blue:0.7, alpha:1)

        
        let days = data["days"] as! Int
        if(days < 0) {
            day.text = "结束"
            dateBg.backgroundColor = UIColor(red:0.42, green:0.42, blue:0.45, alpha:1)
        }else{
            day.text = String(days)
        }
        

    }
    func setRedBg(){
        dateBg.backgroundColor = UIColor.red
    }

}
