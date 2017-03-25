//
//  LoginController.swift
//  funny-class
//
//  Created by vzyw on 12/17/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var postData:Parameters = ["username":"","password":"","imgcode":""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.delegate = self
        password.delegate = self
        
        initCom(view: username)
        initCom(view: password)
        initCom(view: loginBtn)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCom(view:UIView){
        let radius = username.frame.size.height/2
        
        view.layer.cornerRadius = radius
        //view.layer.borderWidth = 0.5
        //view.layer.borderColor = UIColor.black.cgColor
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        let rect = CGRect(origin: CGPoint(x: 0, y: -160), size: self.view.frame.size)
        self.view.frame = rect
        UIView.commitAnimations()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    
    
    @IBAction func pressLoginBtn(_ sender: Any) {
        if(!validCheck()) { return }
        postData["username"] = username.text!
        postData["password"] = password.text!
        
        //closeKeyboard()
        loginBtn.isEnabled = false
        self.pleaseWait();
        
        Login.getImgCode(callback: {response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                self.clearAllNotice()
                self.showAuthImg(image!)
            }
            self.loginBtn.isEnabled = true
        })

    }
    
    func showAuthImg(_ image:UIImage){
        let imageView = UIImageView(image: image)
        let alert = UIAlertController(title: "请输入验证码", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let textField = alert.textFields![0]
        textField.rightViewMode = UITextFieldViewMode.always
        textField.rightView = imageView
        textField.keyboardType = .asciiCapable
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {(UIAlertAction) in
            self.postData["imgcode"] = textField.text
            self.login()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func login()  {
        self.pleaseWait()
        let userDefaults = UserDefaults.standard
        Login.login(postData: postData, callback:  {response in
            self.clearAllNotice()
            switch response.result {
            case .success(let json):
                let dic = json as! Dictionary<String,AnyObject>
                
                if(dic["code"] as! Int == 0){
                    userDefaults.set(self.postData["username"],forKey:"name")
                    Login.akiKey(callback: { apikey in
                        userDefaults.set(apikey,forKey:"apikey")
                    })
                    
                    self.successNotice(dic["msg"] as! String)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.noticeTop(dic["msg"] as! String,autoClearTime: 6)
                }
                break
            case .failure( _):
                self.errorNotice("登陆出错")
            }
        })
    }
    
    func validCheck() -> Bool{
        if(username.text == ""){
            self.infoNotice("请输入用户名")
            return false
        }
        if(password.text == ""){
            self.infoNotice("未输入密码")
            return false
        }
        
        return true
    }
    
}
