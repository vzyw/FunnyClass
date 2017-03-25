//
//  CoursesController.swift
//  funny-class
//
//  Created by vzyw on 12/13/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class CoursesController: UIViewController,CoursesViewHeaderListener,
        CoursersViewHeader_titleDelegate,DaySelectorDelegate,UITableViewDelegate,UITableViewDataSource,DateAndWeekDelegate{
    
    var header:CoursesViewHeader!
    var titleView:CoursersViewHeader_title!
    var dateAndweek:DateAndWeek!
    var daySelector:DaySelector!
    var courses:Course!
    
    var inited:Bool = false
    
    var courseDate:Array<Any> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        header = CoursesViewHeader()
        let frame = CGRect(x: 0, y: 0, width: 100, height:44)
        titleView = CoursersViewHeader_title(frame: frame)
        daySelector = DaySelector(frame: CGRect(x:0,y:64,width:Tools.deviceWidth(),height:43))
        courses = Course()

        super.viewDidLoad()
        
        
        titleView.delegate = self
        daySelector.delegate = self

        
        header.addListener(listener: self)
        header.setNavItem(navigationItem: self.navigationItem)
        header.setTitleView(titleView: titleView)
        
        self.view.addSubview(daySelector)

        
        navigationController?.navigationBar.setBackgroundImage(Tools.drawImageFromColor(color: Tools.headerColor(),size: CGSize(width: Tools.deviceWidth(), height: 64.0)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.register(UINib.init(nibName: "ClassCell", bundle: nil), forCellReuseIdentifier: "classCell")
        self.pleaseWait()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!inited){
            dateAndweek = DateAndWeek()
            dateAndweek.delegate = self
        }
    }
        
    
    
    
    //delegate
    func next(){
        var week = titleView.week! + 1
        if(week > dateAndweek.weeks!){
            week = dateAndweek.weeks!
        }
        delegateAction(weekDay: Date(), week: week)
    }
    
    func prev() {
        var week = titleView.week! - 1
        if(week < 1){
            week = 1
        }
        delegateAction(weekDay: Date(), week: week)
    }
    
    func pressbackButton() {
        let week = dateAndweek.currWeek()
        let date = dateAndweek.dateIn(week: week)
        delegateAction(weekDay: date, week: week)
    }
    
    
    func daySelected(day: Int) {
        showCourses(day: day, week: self.titleView.week!)
    }
    
    
    //dateAndWeek初始化完成后自动调用
    func dateAndWeekInitDone(){
        let currWeek = dateAndweek.currWeek()
        let currDate = dateAndweek.dateIn(week: currWeek)
        titleView.setDate(currDate , andWeek: currWeek)
        daySelector.setDateLabels(startDate: currDate)
        initCourseData()
    }
    //delegate-end
    
    private func delegateAction(weekDay:Date,week:Int){
        let date = dateAndweek.dateIn(week: week)
        let day = Tools.dayToInt(day: weekDay)
        titleView.setDate(date, andWeek: week)
        daySelector.setDateLabels(startDate: date)
        daySelector.press(day: day)
    }
    
    
    //tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return courseDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let id = "classCell"
        let cell:ClassCell! = tableView.dequeueReusableCell(withIdentifier: id) as! ClassCell!
        
        
        cell.classInfo = courseDate[indexPath.row] as? Dictionary<String,Any>
        let courseId = cell.classInfo?["kcb_id"] as! Int
        cell.courseInfo = courses.getCourse(byID: courseId )
        
        courses.getNotRead(byId: courseId) { num in
            cell.setNum(num: num)
        }
        
        cell.initView()
        return cell
    }
    //tableview Datasource-end
    
    
    //tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! ClassCell
        let chartViewId = "chartView"
        let view = Tools.viewById(id: chartViewId) as! ChartController
        view.setCourseInfo(dic: cell.courseInfo!)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    //tableview Delegate-end
    private func initCourseData(){
        courses.getCourse(termId: dateAndweek.term!) { (flag, msg) in
            self.clearAllNotice()
            if(!flag){
                self.errorNotice(msg)
                Login.showLoginView(target: self)
                return
            }
            let day = Tools.dayToInt(day: Date())
            self.daySelector.press(day:day)
            self.inited  = true
        }
    }
    
    private func showCourses(day:Int,week:Int){
        self.courseDate = self.courses.getCourses(byWeek: week, andDay: day)
        self.tableView.reloadData()
    }
}
