//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/14/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var inputLbl: UITextField!
    @IBOutlet weak var outputLbl: UILabel!
    
    
    @IBAction func numPressed(_ sender: UIButton) {
        //print("Num Pressed: \((sender.titleLabel?.text)!)")
        let numInput = (sender.titleLabel?.text)!
        let currentNum = (inputLbl.text!)
        inputLbl.text = "\(currentNum + numInput)"
        
    }
    
    @IBAction func deleteBtn() {
        var delFromInput = inputLbl.text!
        delFromInput.remove(at: delFromInput.index(before: delFromInput.endIndex))
        inputLbl.text = delFromInput
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

