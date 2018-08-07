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
func runTask( log :inout String) -> Bool {
    // define the program to be run
    // define the arguments
    let Path = "/usr/sbin/sysadminctl"
    let Arguments = ["-secureTokenStatus", userName]
    // initialize the task
    let Task = Process()
    // create the output
    let stdOut = Pipe()
    let stdError = Pipe()
    // apply options to task
    Task.launchPath = Path
    Task.arguments = Arguments
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
    if(errorStr!.contains("ENABLED")) {
        return true
    }
    
    return false
}

func Main() {
    var hdsLog = String()
    

    if(runTask(log: &hdsLog)) {
        print("You made it for real this time\n")
    }
    
    
}

Main()

