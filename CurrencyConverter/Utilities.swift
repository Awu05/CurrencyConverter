//
//  Utilities.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/14/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import Foundation


class Utilities {
    
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
    
    
}
