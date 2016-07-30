//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by Alex Bepple on 30 Jul 2016.
//  Copyright © 2016 Alex Bepple. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var chompPlayer:AVAudioPlayer? = nil
    
    func loadSound(filename:NSString) -> AVAudioPlayer? {
        let url = NSBundle.mainBundle().URLForResource(filename as String, withExtension: "caf")!
        do {
            let player = try AVAudioPlayer(contentsOfURL: url)
            player.prepareToPlay()
            return player
        } catch let error as NSError {
            NSLog("Error loading \(url): \(error.localizedDescription)")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filteredSubviews = self.view.subviews.filter({ $0.isKindOfClass(UIImageView) })
        for view in filteredSubviews {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
        }
        self.chompPlayer = self.loadSound("chomp")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.chompPlayer?.play()
    }
    
    func gestureRecognizer(recognizer:UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
}

