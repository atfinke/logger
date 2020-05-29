//
//  main.swift
//  logger
//
//  Created by Andrew Finke on 5/22/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import os.log

let log = OSLog(subsystem: "com.andrewfinke.logger", category: "general")
os_log("Starting", log: log, type: .info)

let defaults = UserDefaults.standard
let _ = Logger.current
RunLoop.main.run()

