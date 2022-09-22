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
        if animationView != nil {
            animationView.startAnimatingGif()
        } else {
            performSegue(withIdentifier: "LaunchToRoot", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension LaunchViewController: SwiftyGifDelegate {
    
    func gifDidStop(sender: UIImageView) {
        animationView.isHidden = true
        performSegue(withIdentifier: "LaunchToRoot", sender: self)
    }
}
