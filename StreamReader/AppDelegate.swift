//
//  AppDelegate.swift
//  StreamReader
//
//  Created by Louis Melahn on 11/19/15.
//  Copyright © 2015 Louis Melahn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if let sr = StreamReader(path: "/Users/lmelahn/Desktop/randomize_mac_address.sh") {
            while let line = sr.nextLine() {
                print(line)
            }
        }
        print("")
        if let sr = StreamReader(path: "/Users/lmelahn/Desktop/randomize_mac_address.sh") {
            for line in sr {
                print(line)
            }
        }
        
        
        let task = NSTask()
        task.launchPath = "/Users/lmelahn/Desktop/EmitNumbersAtIntervals.app"

        let pipe = NSPipe()
        task.standardOutput = pipe
            
        task.launch()
        if let sr = StreamReader(fileHandle: pipe.fileHandleForReading) {
            for line in sr {
                print(line)
            }
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

