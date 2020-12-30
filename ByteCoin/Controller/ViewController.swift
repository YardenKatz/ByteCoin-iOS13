//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
   
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
        
        getPrivateApiKey()
    }

    func getPrivateApiKey() {
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
            if let keys = NSDictionary(contentsOfFile: path) {
                coinManager.apiKey = keys["privateKey"] as? String
            }
            
        }

    }
    //MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
    
    //MARK: - CoinManagerDelegate

    func updateCoinRate(currency: String, rate: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = rate
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

