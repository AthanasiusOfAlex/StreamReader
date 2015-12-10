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
        
//        func updateProgressIndicator(newValue: Double) {
//            self.progressIndicator.doubleValue = newValue
//        }
//        
//        func finalizeProgressIndicator() {
//            self.progressIndicator.doubleValue = 100
//        }
        
        let saveToFolder = "/Users/lmelahn/Desktop/iBreviary"
        
        runBreviaryExtractor(
            "/Users/lmelahn/Projects/BreviaryExtractor/BreviaryExtractor/bin/Debug",
            application: "BreviaryExtractor.app",
            arguments: ["--language=en", "--numberOfDays=3", "--saveToFolder=\(saveToFolder)"],
            taskToPerform: { (newValue: Double) in self.progressIndicator.doubleValue = newValue },
            endgameTask: { () in self.progressIndicator.doubleValue = 100 }
        )

    }
    
    func runBreviaryExtractor(
        workingPath: String,
        application: String,
        arguments: [String],
        taskToPerform: (Double)->(),
        endgameTask: ()->())
    {
        let launchPath = (Path(workingPath) + Path(application)).path
        
        let task = NSTask()

        task.currentDirectoryPath = workingPath
        task.launchPath = launchPath
        task.arguments = arguments
        
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
                    if let str = NSString(data: data, encoding: NSUTF8StringEncoding) as String?,
                        newValue = Double(str.trimEverything) {                                                  taskToPerform(newValue)
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
                // Process was terminated. Hence, run the endgame task
                endgameTask()
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