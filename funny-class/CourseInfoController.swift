//
//  CourseInfoController.swift
//  funny-class
//
//  Created by vzyw on 12/29/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class CourseInfoController: UIViewController {
    
    var courseInfo:Dictionary<String,Any>?

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var person: UILabel!
    @IBOutlet weak var weeks: UILabel!
    
    
    @IBOutlet weak var progressBar: UIProgressView!

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    var like:Int = 0
    var disLike:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    

    func initView(){
        courseName.text = courseInfo!["kc_mc"] as? String
        name.text = courseInfo!["kcb_rkjs_desc"] as? String
        credit.text = String(courseInfo!["kc_xf"] as! Int) + "学分"
        person.text = String(courseInfo!["kcb_rs"] as! Int) + "人修这门课"
        weeks.text = (courseInfo!["kcb_qzz"] as? String)! + "周"
        
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        if (sender.tag == 1){
            like += 1
            likeLabel.text = String(like)
        }else{
            disLike += 1
            dislikeLabel.text = String(disLike)
        }
        initLikeBar()
    }
    
    
    func initLikeBar() {
        if disLike == 0  {
            self.progressBar.progress = 1
        }else {
            self.progressBar.progress = (Float(like)) / Float(like + disLike)
        }
    }

}
