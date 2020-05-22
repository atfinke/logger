//
//  ClickProcessing.swift
//  logger
//
//  Created by Andrew Finke on 5/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import os.log

class ClickProcessing {
    
    // MARK: - Properties -
    
    private static let key = "ClickProcessingClicks"
    private var clicksToWrite = 0
    
    // MARK: - Helpers -
    
    func clicked() {
        clicksToWrite += 1
    }
    
    // MARK: - Write -
    
    func write() {
        guard clicksToWrite > 0 else {
            return
        }
        let clicks = UserDefaults.standard.integer(forKey: ClickProcessing.key)
        UserDefaults.standard.set(clicks + clicksToWrite, forKey: ClickProcessing.key)
        clicksToWrite = 0
    }
    
    // MARK: - Stats -
    
    func stats() {
        os_log(
            "Total Clicks: %{public}i",
            log: log,
            type: .info,
            UserDefaults.standard.integer(forKey: ClickProcessing.key))
    }
}
