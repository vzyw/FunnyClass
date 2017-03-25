//
//  ChartController.swift
//  funny-class
//
//  Created by vzyw on 12/24/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class ChartController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SocketDelegate{

    var courseInfo:Dictionary<String,Any>? = nil
    var roomId:Int? = nil
    var anonName:String?

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var plusButton: UIButton!
    
    var data:[Dictionary<String,Any>] = []
    let socket = SocketMannage.shareInstance()
    let db = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67
        
        textField.layer.cornerRadius = textField.frame.size.height / 2
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.size.height))
        textField.leftViewMode = UITextFieldViewMode.always;
        textField.leftView = leftView
        textField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        initHead()
        
        socket.delegate = self
        
        self.pleaseWait()
    }
    
    private func initHead() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)

        let info = UIButton(type: .infoDark)
        info.addTarget(self, action: #selector(pressInfo(sender:)), for: UIControlEvents.touchDown)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: info)
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.connect()
    }

    //tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let id = "messageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! MessageCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    
    
    //textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text{
            let temp = text.trimmingCharacters(in: CharacterSet.whitespaces)
            if(temp.characters.count != 0){
                self.socket.sendMessage(data: text, nicked: plusButton.isSelected)
            }
            textField.text = ""
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    
    func closeKeyboard(){
        textField.resignFirstResponder()
        tableView.resignFirstResponder()
    }
    
    
    func keyBoardWillShow(_ notification:Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        let changeY = kbRect.origin.y - Tools.deviceHeight()
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            
            self.view.transform = CGAffineTransform(translationX: 0, y: changeY)
        }
    }
    
    func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    
    
    
    
    func setCourseInfo(dic:Dictionary<String,Any>){
        courseInfo = dic
        self.title = dic["kc_mc"] as? String
        self.roomId = dic["kcb_id"] as? Int
        initChatData()
    }
    
    private func initChatData(){
        //self.pleaseWait()
        DispatchQueue.global().async {
            while self.courseInfo == nil{}
            while !self.socket.logined {}
            
            let roomId = self.roomId!
            self.socket.joinRoom(roomId: roomId) { flag,anonName in
                print(anonName)
                self.anonName = anonName
                self.data = self.db.getNews(roomId: self.roomId!)
                self.tableViewReload()
                self.clearAllNotice()
            }
        }
    }
    
    
    
    
    
    //socket delegate
    func newMessage(_ data: Dictionary<String,Any>) {
        
        print(data)
        //todo
        
        self.data.append(data)
        self.tableViewReload()
        db.storeNews(roomId: roomId!, news: [data])
    }
    

    
    func tableViewReload(){
        tableView.reloadData()
        scrollToFoot(animated: false)
    }
    
    func scrollToFoot(animated:Bool){
        let section = tableView.numberOfSections
        if(section < 1) {return}
        let row = tableView.numberOfRows(inSection: section - 1)
        if(row < 1) {return}
        let indexPath = IndexPath(row: row - 1, section: section - 1)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    

    
    @IBAction func pressPlus(_ sender: UIButton) {
        if(anonName == nil){
            return self.errorNotice("开启匿名出错")
        }
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            self.successNotice("开启匿名成功")
        }else{
            self.successNotice("匿名关闭")
        }
    }
    
    
    @objc private func pressInfo(sender:UIButton){
        let id = "infoView"
        let view = Tools.viewById(id: id) as! CourseInfoController
        view.courseInfo = self.courseInfo
        self.navigationController?.pushViewController(view, animated: true)
    }

}
