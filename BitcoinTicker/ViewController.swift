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

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","UAH","ZAR"]
    let currencyLabelsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "₴", "R"]
    var finalURL = ""
    var currentCurrencySymbol = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        let randomStartIndex = Int.random(in: 0...currencyArray.count)
        
        finalURL = baseURL + currencyArray[randomStartIndex]
        currentCurrencySymbol = currencyLabelsArray[randomStartIndex]
        
        getBitcoinCurrencyData(url: finalURL)
        
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        currentCurrencySymbol = currencyLabelsArray[row]
        
        getBitcoinCurrencyData(url: finalURL)
    }
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinCurrencyData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin currency data")
                    let bitcoinCurrencyJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinCurrencyData(json: bitcoinCurrencyJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinCurrencyData(json : JSON) {
        
        if let bitcoinCurrencyResult = json["last"].double {
            bitcoinPriceLabel.text = currentCurrencySymbol + String(bitcoinCurrencyResult)
        } else {
            bitcoinPriceLabel.text = "Unable to get data"
        }
    }

}

