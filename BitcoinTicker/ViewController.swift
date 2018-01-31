//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var symbolIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    
    func updateUI(price : Double){
    
    bitcoinPriceLabel.text = "\(currencySymbol[symbolIndex]) \(price)"
    
    }
    
    
    

    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let weatherJSON : JSON = JSON(response.result.value!)
                    
                    self.updateBitCoinData(json: weatherJSON)
                    
                } else {
                    print("Error: \(response.result.error)")
                }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitCoinData(json : JSON) {
        
        if let tempResult = json["open"]["hour"].double{
        
            updateUI(price : tempResult)
        }else {
             bitcoinPriceLabel.text = "Price UnAvailable"
        }
    }
    

    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL+currencyArray[row]
        symbolIndex = row
        getBitcoinData(url : finalURL)
        
    }


}

