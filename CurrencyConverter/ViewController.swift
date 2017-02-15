//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/14/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var inputLbl: UITextField!
    @IBOutlet weak var outputLbl: UILabel!
    
    @IBOutlet weak var fromCurrency: UITextField!
    
    @IBOutlet weak var toCurrency: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let pickerView = UIPickerView()
    
    let currencyType = ["AUD","BGN","BRL","CAD","CHF","CNY","CZK","DKK", "EUR","GBP","HKD","HRK","HUF","IDR","ILS","INR","JPY","KRW","MXN","MYR","NOK","NZD","PHP","PLN","RON","RUB","SEK","SGD","THB","TRY", "USD","ZAR"]
    
    var isFromCurrency = false
    var isToCurrency = false
    
    
    @IBAction func numPressed(_ sender: UIButton) {
        //print("Num Pressed: \((sender.titleLabel?.text)!)")
        let numInput = (sender.titleLabel?.text)!
        let currentNum = (inputLbl.text!)
        inputLbl.text = "\(currentNum + numInput)"
        
    }
    
    @IBAction func deleteBtn() {
        var delFromInput = inputLbl.text!
        
        if delFromInput.characters.count > 0 {
            delFromInput.remove(at: delFromInput.index(before: delFromInput.endIndex))
            inputLbl.text = delFromInput
        }
    }
    
    @IBAction func swapBtn() {
        let temp = fromCurrency.text
        
        fromCurrency.text = toCurrency.text
        toCurrency.text = temp
        
        self.view.endEditing(true)
    }
    
    @IBAction func convertBtn() {
        
        self.view.endEditing(true)
        
        if (fromCurrency.text! == "") || (toCurrency.text! == "" ) {
            let alertController = UIAlertController(title: "Empty Currency Field", message:
                "You have left a empty currency field.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            Utilities.getExchangeRates(fromCurrency: fromCurrency.text!, toCurrency: toCurrency.text!) { (exchangeRate) in
                
                DispatchQueue.main.async {
                    guard let amount:Double = Double(self.inputLbl.text!)
                        else {
                            
                            let exchangeRateTotal = 1 * exchangeRate
                            
                            self.outputLbl.text = String(format: "%.4f", exchangeRateTotal)
                            
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            
                            return
                    }
                    
                    let exchangeRateTotal = amount * exchangeRate
                    
                    self.outputLbl.text = String(format: "%.4f", exchangeRateTotal)
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        fromCurrency.delegate = self
        toCurrency.delegate = self
        
        activityIndicator.isHidden = true
        
        pickerView.reloadAllComponents()
        
        fromCurrency.inputView = pickerView
        toCurrency.inputView = pickerView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
        
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return currencyType.count
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            isFromCurrency = true
            isToCurrency = false
            pickerView.isHidden = false
            //fromCurrency.text = currencyType[0]
            
        } else if textField.tag == 2 {
            isFromCurrency = false
            isToCurrency = true
            pickerView.isHidden = false
            //toCurrency.text = fromCurrency.text
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        //check to see which field we are manipulating
        if isFromCurrency == true {
            fromCurrency.text = currencyType[row]
        } else if isToCurrency == true {
            toCurrency.text = currencyType[row]
        }
        
    }
    

}

