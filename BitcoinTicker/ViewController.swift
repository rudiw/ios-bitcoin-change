//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,
    UIPickerViewDataSource, UIPickerViewDelegate {
    
    let BASE_URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self;
        currencyPicker.delegate = self;
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return currencyArray[row];
        }
        return "?????";
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("component: \(component)");
//        print("row: \(row)");
        if (component == 0) {
            print("selected value is '\(currencyArray[row])'");
            
            let finalURL = BASE_URL + currencyArray[row];
            print("selected value is '\(finalURL)'");
            
            getChange(url: finalURL, parameters: [:], index: row);
        } else {
            print("Unrecognized selected value?????");
        }
        
    }
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getChange(url: String, parameters: [String : String], index: Int) {
        
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the change")
                    let changeJson : JSON = JSON(response.result.value!)
//                    print("changeJson: \(changeJson)");

                    self.updateWeatherData(json: changeJson, symbol: self.currencySymbolArray[index])

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateWeatherData(json : JSON, symbol: String) {
        
        if let price = json["ask"].double {
            self.bitcoinPriceLabel.text = "\(symbol)\(price)";
        } else {
            self.bitcoinPriceLabel.text = "Unavailable";
        }
        
    }
//




}

