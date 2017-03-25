//
//  MeController.swift
//  funny-class
//
//  Created by vzyw on 12/19/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class MeController: UIViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var btnView: UIView!
    
    let btnData:Array = ["exam_btn","score_btn","credit_btn","evaluation_btn"]
    let btnTitle:Array = ["考试安排","成绩查询","学分查询","综合测评"]
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        userImg.layer.cornerRadius = userImg.frame.size.width / 2
        userImg.clipsToBounds = true
        initButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let name = userDefaults.value(forKey: "name"){
            userName.text = (name as! String).uppercased()
        }else{
            Login.showLoginView(target: self)
        }
    }
    
    
    @IBAction func loginOut(_ sender: Any) {
        userDefaults.removeObject(forKey: "logined")
        userDefaults.removeObject(forKey: "name")
        Login.LoginOut()
        Login.showLoginView(target: self)
    }
    
    
    func initButton(){
        let width = (Tools.deviceWidth()+CGFloat(btnData.count)) / CGFloat(btnData.count)
        var rect = CGRect(x: 0, y: 0, width: width, height: width)
        for i in 0...(btnData.count - 1){
            let button = FunButton(frame: rect, name: btnData[i], title: btnTitle[i])
            button.tag = i
            button.addTarget(self, action: #selector(self.pressFunButton(button:)), for: UIControlEvents.touchDown)
            self.btnView.addSubview(button)
            rect.origin.x += width-1
        }
    }
    
    func pressFunButton(button:UIButton){
        switch(button.tag){
        case 0:
            let view = Tools.viewById(id: "examsView")
            self.navigationController?.pushViewController(view, animated: true)
        case 1:
            print(2)
        case 2:
            print(3)
        case 3:
            print(4)
        default: break
        }

    }
    
    
}






