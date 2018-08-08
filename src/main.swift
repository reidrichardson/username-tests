//
//  main.swift
//  username tests
//
//  Created by Reid Richardson on 8/7/18.
//  Copyright © 2018 Reid Richardson. All rights reserved.
//

import Foundation

// set current user's login name
let userName = NSUserName()

// uses inout so the parameter can be edited
func runTask( log :inout String, zPath :String, zArgs :[String]) -> Bool {
    // initialize the task
    let Task = Process()
    // create the output
    let stdOut = Pipe()
    let stdError = Pipe()
    // apply options to task
    Task.launchPath = zPath
    Task.arguments = zArgs
    Task.standardOutput = stdOut
    Task.standardError = stdError

    // start the task
    Task.launch()
    // collect standard output data
    let data = stdOut.fileHandleForReading.readDataToEndOfFile()
    let outputStr = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    //collect standard error data
    let error = stdError.fileHandleForReading.readDataToEndOfFile()
    let errorStr = String(data: error, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    Task.waitUntilExit()
    // Exit task
    // Write the Error to log
    log.append("Error: \n")
    log.append(errorStr!)
    // Write standard out to log
    log.append("\n------------\n Standard Out\n")
    log.append(outputStr!)
    
    // returns true if secureTokenStatus is enabled for the user
    if(zPath == "/usr/sbin/sysadminctl" && errorStr!.contains("ENABLED")) {
    return true
    }
    
    return false
}

func Main() {
    // initializes
    var hdsLog = String()
    let sysadminctl = "/usr/sbin/sysadminctl"
    let stsArg = ["-secureTokenStatus", userName]
    let stsTask = runTask(log: &hdsLog, zPath: sysadminctl, zArgs: stsArg)
    if (stsTask) {
        print("You made it for real this time\n")
    }
    
    //if(runTask(log: &hdsLog, zPath: sysadminctl, zArgs: stsArg)) {
      //  print("You made it for real this time\n")
    
    addUser()
}

func addUser() {
    var thisLog = String()
    print("Enter password: ")
    let password = readLine()
    let myPath = "/usr/sbin/sysadminctl"
    
    let enableArg = ["-addUser", userName, password!]
    let userTask = runTask(log: &thisLog, zPath: myPath, zArgs: enableArg)
    
    print(thisLog)
}
    


Main()

