//
//  ViewController.swift
//  SwiftySurrogate
//
//  Created by zh-wang on 07/01/2015.
//  Copyright (c) 07/01/2015 zh-wang. All rights reserved.
//

import UIKit
import SwiftySurrogate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label: UILabel = UILabel(frame: CGRectMake(0, self.view.frame.midY - 50, self.view.frame.width, 100))
        label.text = "input: D83D:DCC9 | 0xD83C, 0xDF80 | 0x2702"
        self.view.addSubview(label)
        
        let label2: UILabel = UILabel(frame: CGRectMake(0, self.view.frame.midY - 50 - 100, self.view.frame.width, 100))
        let emoji1 = SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "D83D:DCC9")
        let emoji2 = SwiftySurrogate.decodeFromSurrogatePair(high: 0xD83C, low: 0xDF80)
        let emoji3 = String(UnicodeScalar(0x2702))
        label2.text = "\(emoji1) | \(emoji2) | \(emoji3)"
        self.view.addSubview(label2)
        
        // This will fail
        if let _ = SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "FFFF:DE04") {
            
        } else {
            // Get the error
            print(SwiftySurrogate.lastError())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

