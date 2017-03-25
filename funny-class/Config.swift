//
//  Config.swift
//  funny-class
//
//  Created by vzyw on 12/17/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import  UIKit


let IP = "120.77.36.235"
let PORT = "3000"
let LOGIN = "/user/login"
let SCHEDULE = "/user/class-schedule"
let LONGINOUT = "/user/sign-out"
let CHARTTOKEN = "/user/chart-token"
let EXAMS = "/user/exams"


class Configs:NSObject{
    static let baseURL = "http://" + IP + ":" + PORT
    static let loginURL = baseURL + LOGIN
    static let coursesURL = baseURL + SCHEDULE
    static let loginOutURL = baseURL + LONGINOUT
    static let weekURL = baseURL + "/week"
    static let infoURL = baseURL + "/info"
    static let termURL = baseURL + "/term"
    static let apikeyURL = baseURL + CHARTTOKEN
    static let examsURL = baseURL + EXAMS
    
    static let socketURL = "http://" + IP + ":2233"
}
