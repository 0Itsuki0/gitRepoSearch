//
//  LaunchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by イツキ on 2022/09/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import SwiftyGif

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var LuanchImageView: UIImageView!
    
    var animationView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // try load gif file
            let gif = try UIImage(gifName: "launchScreen4x.gif")
            animationView = UIImageView(gifImage: gif, loopCount: 1)
            animationView.frame = LuanchImageView.bounds
            LuanchImageView.image = nil
            LuanchImageView.addSubview(animationView)
            animationView.delegate = self
            
        } catch {
            print(error)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // play gif if availabe
        if animationView != nil {
            animationView.startAnimatingGif()
        } else {
            performSegue(withIdentifier: "LaunchToRoot", sender: self)
        }
    }


}


extension LaunchViewController: SwiftyGifDelegate {
    
    // move to the main search after playing gif
    func gifDidStop(sender: UIImageView) {
        animationView.isHidden = true
        performSegue(withIdentifier: "LaunchToRoot", sender: self)
    }
}
