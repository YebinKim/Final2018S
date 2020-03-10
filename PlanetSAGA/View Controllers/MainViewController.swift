//
//  MainViewController.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        SoundManager.clickEffect()
    }
}
