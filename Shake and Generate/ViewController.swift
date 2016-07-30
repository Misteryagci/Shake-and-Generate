//
//  ViewController.swift
//  Shake and Generate
//
//  Created by Kaan Yagci on 27/07/2016.
//  Copyright © 2016 Androctone. All rights reserved.
//

import UIKit
import CoreMotion



class ViewController: UIViewController {

    let motionManager = CMMotionManager()
    // MARK: Properties
    @IBOutlet weak var majuscule: UISwitch!
    @IBOutlet weak var minuscule: UISwitch!
    @IBOutlet weak var chiffre: UISwitch!
    @IBOutlet weak var specialChar: UISwitch!
    @IBOutlet weak var changeSize: UIStepper!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var printedText: UITextView!
    @IBAction func sizeChanged(_ sender: AnyObject) {
        let step : UIStepper = sender as! UIStepper
        size.text = Int(step.value).description
    }
    
    override func viewDidLoad() {
        if motionManager.isGyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.2;
            motionManager.startDeviceMotionUpdates()
            
            motionManager.gyroUpdateInterval = 0.2
            if OperationQueue.current != nil {
                motionManager.startGyroUpdates()
                if motionManager.gyroData != nil {
                }
            }
        } else {
            // alert message
        }

        super.viewDidLoad()
        changeSize.wraps = true
        changeSize.autorepeat = true
        changeSize.maximumValue = 64
        changeSize.minimumValue = 8
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.printedText.text = generateCode(maj: majuscule.isOn, min: minuscule.isOn, num: chiffre.isOn, spe: specialChar.isOn, size: Int(size.text!)!)
        }
    }
    
   
    
    func generateCode (maj : Bool,min : Bool, num : Bool, spe : Bool, size : Int) -> String {
        let lowerCaseLetters = Array("abcdefghijklmnopqrstuvwxyz".characters)
        let upperCaseLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
        let numbers = Array("0123456789".characters)
        let specialChars = Array("[?/<~#`!@$%^&*()+=}|:\";'>{ ".characters)
        var res = ""
        
        if (maj == false) && (min == false) && (num == false) && (spe == false) {
            res = "Vous devez choisir ou moins une type de caractère pour qu'on puisse générer"
        }
        else {
            var idx = 0
            while idx < size {
                switch arc4random_uniform(4) {
                case 0 :
                    if min {
                        res += String(lowerCaseLetters[Int(arc4random_uniform(UInt32(lowerCaseLetters.count)))])
                        idx += 1
                    }
                case 1 :
                    if maj {
                        res += String(upperCaseLetters[Int(arc4random_uniform(UInt32(upperCaseLetters.count)))])
                        idx += 1
                    }
                case 2 :
                    if num {
                        res += String(numbers[Int(arc4random_uniform(UInt32(numbers.count)))])
                        idx += 1
                    }
                default :
                    if spe {
                        res += String(specialChars[Int(arc4random_uniform(UInt32(specialChars.count)))])
                        idx += 1
                    }
                    break
                }
            }
        }
        return res
    }
}

