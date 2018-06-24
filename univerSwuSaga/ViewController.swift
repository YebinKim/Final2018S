//
//  ViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 14..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = UIImage(named: "Background.png")
        
        appDelegate.ID = nil
        appDelegate.userName = "Guest"
        appDelegate.flagLogin = false
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
    }
}
