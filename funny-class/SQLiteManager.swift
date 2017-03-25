//
//  SQLiteManager.swift
//  funny-class
//
//  Created by vzyw on 12/24/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    static let instance = SQLiteManager()
    //对外提供创建单例对象的接口
    class func shareInstance() -> SQLiteManager {
        return instance
    }
    
    
    
    var db : OpaquePointer? = nil
    //打开数据库
    func openDB() -> Bool {
        //数据库文件路径
        let dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let DBPath = (dicumentPath! as NSString).appendingPathComponent("news.sqlite")
        let cDBPath = DBPath.cString(using: String.Encoding.utf8)
        //打开数据库
        //第一个参数:数据库文件路径  第二个参数:数据库对象
        //        sqlite3_open(filename: UnsafePointer<Int8>!, ppDb: UnsafeMutablePointer<OpaquePointer?>!)
        if sqlite3_open(cDBPath, &db) != SQLITE_OK {
            print("数据库打开失败")
            return false
        }
        return true
        //return creatTable();
    }
    
    //创建表
    func creatTable(creatNewsTable:String) -> Bool {
        return creatTableExecSQL(SQL_ARR: [creatNewsTable])
    }
    
    func creatTableExecSQL(SQL_ARR : [String]) -> Bool {
        for item in SQL_ARR {
            if execNonSQL(SQL: item) == false {
                return false
            }
        }
        return true
    }
    
    func execNonSQL(SQL : String) -> Bool {
        // 1.将sql语句转成c语言字符串
        let cSQL = SQL.cString(using: String.Encoding.utf8)
        //错误信息
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        if sqlite3_exec(db, cSQL, nil, nil, errmsg) == SQLITE_OK {
            return true
        }else{
            print("SQL 语句执行出错 -> 错误信息: 一般是SQL语句写错了 \(errmsg)")
            return false
        }
    }
    
    func fetch(tableName :String, cond :String?, order :String?)-> OpaquePointer?{
            var statement :OpaquePointer? = nil
            var sql = "select * from \(tableName)"
            if let condition = cond {
                sql += " where \(condition)"
            }
            
            if let orderBy = order {
                sql += " order by \(orderBy)"
            }
            
            sqlite3_prepare_v2(
                self.db, (sql as NSString).utf8String, -1,
                &statement, nil)
            
            return statement
    }
    
    func insert(tableName :String, rowInfo :[String:String]) -> Bool {
        var statement :OpaquePointer? = nil
        let sql = "insert into \(tableName) " + "(\(rowInfo.keys.joined(separator: ","))) "+"values "+"(\(rowInfo.values.joined(separator: ",")))" as NSString
            
        if sqlite3_prepare_v2(
            self.db, sql.utf8String, -1, &statement, nil)
            == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }
        
        return false
    }
    
}
