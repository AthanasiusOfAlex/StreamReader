//
//  MasterViewController.swift
//  StreamReader
//
//  Created by Louis Melahn on 11/20/15.
//  Copyright © 2015 Louis Melahn. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "sleep1; echo 10 ; sleep 1 ; echo 20 ; sleep 1 ; echo 30 ; sleep 1 ; echo 40; sleep 1; echo 50; sleep 1; echo 60; sleep 1"]
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var progressObserver : NSObjectProtocol!
        progressObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification,
            object: outHandle, queue: nil) {
                notification -> Void in
                let data = outHandle.availableData
                if data.length > 0 {
                    if let str = NSString(data: data, encoding: NSUTF8StringEncoding) as String? {
                        if let newValue = Double(str.trimEverything) {
                            self.progressIndicator.doubleValue = newValue
                        }
                    }
                    outHandle.waitForDataInBackgroundAndNotify()
                } else {
                    // That means we've reached the end of the input.
                    NSNotificationCenter.defaultCenter().removeObserver(progressObserver)
                }
        }
        
        var terminationObserver : NSObjectProtocol!
        terminationObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSTaskDidTerminateNotification,
            object: task, queue: nil) {
                notification -> Void in
                // Process was terminated. Hence, progress should be 100%
                self.progressIndicator.doubleValue = 100
                NSNotificationCenter.defaultCenter().removeObserver(terminationObserver)
        }
        
        task.launch()

    }
}


extension String {
    var trimEverything: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}