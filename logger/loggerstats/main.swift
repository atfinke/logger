//
//  AppDelegate.swift
//  loggerstats
//
//  Created by Andrew Finke on 5/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import os.log

let log = OSLog(subsystem: "com.andrewfinke.logger.stats", category: "general")
let defaults = UserDefaults(suiteName: "com.andrewfinke.logger") ?? UserDefaults.standard

ClickProcessing().stats()
KeyProcessing().stats()
