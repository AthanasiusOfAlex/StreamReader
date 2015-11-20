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
    var masterViewController: MasterViewController!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // 1. Initialize the MasterViewController
        masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        
        // 2. Set up the data model here (empty for now).
        
        // 3. Connect the MasterViewController to the window
        window.contentView!.addSubview(masterViewController.view)
        
        // 4. Set the window's frame to take up the entire content view.
        masterViewController.view.frame = (window.contentView! as NSView).bounds
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

