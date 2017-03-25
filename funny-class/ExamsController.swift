//
//  ExamsController.swift
//  funny-class
//
//  Created by vzyw on 12/29/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class ExamsController: UITableViewController {

    var data:[Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "考试倒计时"
        self.pleaseWait()
        Exams.examsData { (flag, arr) in
            if(flag){
                self.data = arr!
                self.sort()
                self.tableView.reloadData()
                self.clearAllNotice()
            }else{
                self.errorNotice("暂时无法查询")
            }
        }
        
    }
    
    private func sort(){
        var arr:Array<Dictionary<String,Any>> = []
        for var item in data{
            let date = Tools.stringToDate(date: item["ksap_ksrq"] as! String, formart:"yyyy-MM-dd")
            let days = Tools.daysBetweenNow(date: date)
            
            item["days"] = days
            if(days<0){
                arr.append(item)
            }else{
                arr.insert(item, at: 0)
            }
        }
        self.data = arr
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath) as! ExamCell
        
        cell.setData(data: data[indexPath.row])
        if(indexPath.row == 0){
            cell.setRedBg()
        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
