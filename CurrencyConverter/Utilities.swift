//
//  Utilities.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/14/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit
import SystemConfiguration


class Utilities {
    
    static var mySharedData = DataAccessObject.sharedManager
    
    static func getExchangeRates(fromCurrency:String, toCurrency:String, completion:@escaping (_ info:Double) -> Void) {
        //http://stackoverflow.com/questions/3139879/how-do-i-get-currency-exchange-rates-via-an-api-such-as-google-finance
        //http://api.fixer.io: http://api.fixer.io/latest?base=USD
        
        let url = URL(string: "http://api.fixer.io/latest?base=\(fromCurrency)")
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest) {
            ( data, response, error) in
            
            // perform some action
            guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: AnyObject]
                else {return}
            
            let ratesDict = json?["rates"]
            
            let exchangeRate = ratesDict?[toCurrency]
            
            //print("Exchange Rate is \(exchangeRate)")
            
            completion(exchangeRate as! Double)
            
        }
        
        task.resume()
    }
    
    static func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    static func roundNumber(exchRate:Double) -> Double{
        
        var rate = String(format: "%.6f", exchRate)
        //print("RateStr is: \(rate)")
        
        var zeroCount = 0
        
        while (true) {
            let newStrIndex = rate.index(before: rate.endIndex)
            
            if rate[newStrIndex] == "0" {
                rate.remove(at: newStrIndex)
                zeroCount += 1
            } else {
                if zeroCount == 6 {
                    rate = rate + "00"
                }
                //print("New Rate: \(rate)")
                
                guard let newRate = Double(rate)
                    else { return 0 }
                
                return newRate
            }
            
        }
    }
    
    static func formatCurrency(exchgRate:Double) -> String {
        var rate = String(format: "%.6f", exchgRate)
        //print("RateStr is: \(rate)")
        
        var zeroCount = 0
        
        while (true) {
            let newStrIndex = rate.index(before: rate.endIndex)
            
            if rate[newStrIndex] == "0" {
                rate.remove(at: newStrIndex)
                zeroCount += 1
            } else {
                if zeroCount == 6 {
                    rate = rate + "00"
                }
                
                return rate
            }
            
        }
    }
    
    static func refreshRates(completion:@escaping () -> Void) {
        var currencyCount = 0
        
        for currency in mySharedData.currencyArray {
            //print("Refreshing rates")
            getExchangeRates(fromCurrency: currency.fromCurrency!, toCurrency: currency.toCurrency!, completion: { (newExchgRate) in
                
                let newRate = Utilities.roundNumber(exchRate: newExchgRate)
                
                currency.currentRate = newRate
                
                currencyCount += 1
                
                if currencyCount == mySharedData.currencyArray.count {
                    completion()
                }
            })
            
            
            
        }
        
        
    }
    
}
