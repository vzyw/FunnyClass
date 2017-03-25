//
//  News.swift
//  funny-class
//
//  Created by vzyw on 12/28/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class News: NSObject {
    let db = SQLiteManager.shareInstance()
    
    func getNews(roomId:Int)->[Dictionary<String,Any>]{
        let statement = db.fetch(tableName: "room"+String(roomId), cond: nil, order: "ID asc")
        
        
        var arr:[Dictionary<String,Any>] = []
        while sqlite3_step(statement) == SQLITE_ROW{
            var dic:Dictionary<String,Any> = [:]
            dic["id"] = Int(sqlite3_column_int(statement, 0))
            dic["name"] = String(String.init(cString: sqlite3_column_text(statement, 1)))
            dic["timeStamp"] = Int64(sqlite3_column_int64(statement, 2))
            dic["msg"] = String(String.init(cString:sqlite3_column_text(statement,3)))
            dic["nicked"] = Int(sqlite3_column_int(statement, 4))
            arr.append(dic)
        }
        
        sqlite3_finalize(statement)
        return arr
    }
    
    override init() {
       _ = db.openDB()
    }
    
    func storeNews(roomId:Int,news:[Dictionary<String,Any>]){
        let table = "room"+String(roomId)
        let creatNewsTable = "CREATE TABLE IF NOT EXISTS " + table
            + " ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL,'timeStamp' INTEGER NOT NULL ,'msg' TEXT NOT NULL,'nicked' INTEGER NOT NULL)"
        print(!db.creatTable(creatNewsTable: creatNewsTable))
        
        for item in news{
            var _news:[String:String]=[:]
            _news["name"] = "'"+(item["name"] as! String)+"'"
            _news["msg"] = "'"+(item["msg"] as! String)+"'"
            _news["nicked"] = "'"+String((item["nicked"] as! Int))+"'"
            _news["timeStamp"] = "'"+String((item["timeStamp"] as! Int64))+"'"
            
            _ = db.insert(tableName: table, rowInfo: _news)
        }
        
    }
    
    func lastTimeStamp(roomId:Int)->Int64{
        var id:Int64 = 0
        let statement = db.fetch(tableName: "room"+String(roomId), cond: nil, order: "id desc")
        if statement == nil  {
            return id
        }
        if sqlite3_step(statement) == SQLITE_ROW{
            id = sqlite3_column_int64(statement, 2)
        }
        sqlite3_finalize(statement)
        
        return id
    }
}
