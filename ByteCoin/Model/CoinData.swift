//
//  CoinData.swift
//  ByteCoin
//
//  Created by David Salzer on 30/12/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData : Codable {
    var time: String
    var asset_id_base: String
    var asset_id_quote: String
    var rate: Double
}
