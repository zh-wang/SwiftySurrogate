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
        
        var label: UILabel = UILabel(frame: CGRectMake(0, self.view.frame.midY - 50, self.view.frame.width, 100))
        label.text = "input: D83D:DCC9 | 0xD83C, 0xDF80 | 0x2702"
        self.view.addSubview(label)
        
        var label2: UILabel = UILabel(frame: CGRectMake(0, self.view.frame.midY - 50 - 100, self.view.frame.width, 100))
        var emoji1 = SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "D83D:DCC9")
        var emoji2 = SwiftySurrogate.decodeFromSurrogatePair(high: 0xD83C, low: 0xDF80)
        var emoji3 = SwiftySurrogate.decodeFromUnicodeScalar(0x2702)
        label2.text = "\(emoji1) | \(emoji2) | \(emoji3)"
        self.view.addSubview(label2)
        
            println(SwiftySurrogate.decodeFromSurrogatePair(surrogatePair: "D83D:DE04"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

