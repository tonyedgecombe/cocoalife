//
//  AppDelegate.swift
//  cocoalife
//
//  Created by Tony Edgecombe on 12/04/2020.
//  Copyright © 2020 Tony Edgecombe. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var drawingView: DrawingView!
    
    var started:Bool = false
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    @IBAction func start(_ sender: NSButton) {
        if started {
            drawingView.stop()
        }
        else {
            drawingView.start()
        }
        
        started = !started
        sender.title = started ? "Stop" : "Start"
    }
}

