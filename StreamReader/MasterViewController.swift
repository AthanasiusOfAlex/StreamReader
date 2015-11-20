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
        task.launchPath = "/Applications/EmitNumbersAtIntervals.app"
        
        let pipe = NSPipe()
        task.standardOutput = pipe

        task.launch()

        for line in StreamReader(fileHandle: pipe.fileHandleForReading)! {
            if let newValue = Double(line) {
                progressIndicator.doubleValue = newValue
            }
        }
    }
}
