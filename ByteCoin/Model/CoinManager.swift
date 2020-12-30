//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateCoinRate(currency: String, rate: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    var apiKey: String?
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    mutating func getCoinPrice(for currency: String) {
        if let safeKey = apiKey {
            let url = "\(baseURL)/\(currency)?apikey=\(safeKey)"
            performRequest(with: url, for: currency)
        }
    }
    
    func performRequest(with urlString:String, for currency: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    print("success")
//                    print(String(data: safeData, encoding: .utf8))
                    if let rate = parseJSON(safeData) {
                        let priceString = String(format: "%.2f", rate)
                        delegate?.updateCoinRate(currency: currency , rate: priceString)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        } catch  {
            delegate?.didFailWithError(error: error)
            
            return nil
        }
    }
    
}
