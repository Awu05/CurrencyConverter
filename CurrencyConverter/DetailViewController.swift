//
//  DetailViewController.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/16/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var fromCurrency: UITextField!
    
    @IBOutlet weak var toCurrency: UITextField!
    
    @IBOutlet weak var targetExchgRate: UITextField!
    
    @IBOutlet weak var alertSwitchProperty: UISwitch!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var saveBtnProperty: UIButton!
    
    var mySharedData = DataAccessObject.sharedManager
    
    let pickerView = UIPickerView()
    
    let currencyType = ["AUD","BGN","BRL","CAD","CHF","CNY","CZK","DKK", "EUR","GBP","HKD","HRK","HUF","IDR","ILS","INR","JPY","KRW","MXN","MYR","NOK","NZD","PHP","PLN","RON","RUB","SEK","SGD","THB","TRY", "USD","ZAR"]
    
    var isFromCurrency = false
    var isToCurrency = false
    
    @IBAction func alertSwitch() {
        
        if alertSwitchProperty.isOn == true {
            targetExchgRate.isHidden = false
        } else {
            targetExchgRate.isHidden = true
        }
        
    }
    
    @IBAction func saveBtn() {
        
        let hasNetwork = Utilities.connectedToNetwork()
        
        if hasNetwork == false {
            noNetwork()
        } else {
            self.view.endEditing(true)
            
            saveInfo()
        }
        
        
    }
    
    func saveInfo() {
        var targetRate = 0.0
        
        if alertSwitchProperty.isOn == true {
            //Use a guard/catch statement here
            if (targetExchgRate.text! != "") || (targetExchgRate.text! != "."){
                let targetRateStr = NSDecimalNumber(string: targetExchgRate.text!)
                
                if targetRateStr == NSDecimalNumber.notANumber {
                    targetRate = 0.0
                } else {
                    targetRate = Double(targetExchgRate.text!)!
                }
            }
            
        }
        
        if (fromCurrency.text! == "") || (toCurrency.text! == "" ) {
            let alertController = UIAlertController(title: "Empty Currency Field", message:
                "You have left a empty currency field.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            //print("Target Rate is \(targetRate)")
            
            saveBtnProperty.isEnabled = false
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            Utilities.getExchangeRates(fromCurrency: fromCurrency.text!, toCurrency: toCurrency.text!) { (exchRate) in
                /*
                let rate = String(format: "%.6f", exchRate)
                print("RateStr is: \(rate)")
                */
                
                let rate = Utilities.roundNumber(exchRate: exchRate)
                
                //let trackNewCurrency = Currency(frmCurr: self.fromCurrency.text!, toCurr: self.toCurrency.text!, currRate: rate, targetRate: targetRate)
                
                //let newTrackedCurrency = TrackedCurrency(
                
                //self.mySharedData.currencyArray.append(newTrackedCurrency)
                
                self.mySharedData.addTrackedCurrency(frmCurrency: self.fromCurrency.text!, toCurrency: self.toCurrency.text!, currRate: rate, tarRate: targetRate)
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        targetExchgRate.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        fromCurrency.delegate = self
        toCurrency.delegate = self
        
        activityIndicator.isHidden = true
        
        saveBtnProperty.isEnabled = true
        
        pickerView.reloadAllComponents()
        
        fromCurrency.inputView = pickerView
        toCurrency.inputView = pickerView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
        
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let hasNetwork = Utilities.connectedToNetwork()
        
        if hasNetwork == false {
            noNetwork()
        }
    }
    
    func noNetwork() {
        let alertController = UIAlertController(title: "No Internet!", message:
            "Please check your network settings and make sure that you are connected to a network.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
