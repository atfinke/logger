//
//  ScreenProcessing.swift
//  logger
//
//  Created by Andrew Finke on 5/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class ScreenProcessing {
    
    // MARK: - Properties -
    
    private var folderPath: URL = {
        guard let base = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first else {
                fatalError()
        }
        return base.appendingPathComponent("logger")
    }()
    
    // MARK: - Initalization -
    
    init() {
        try? FileManager.default.createDirectory(
            at: folderPath,
            withIntermediateDirectories: false,
            attributes: nil)
        
        Timer.scheduledTimer(withTimeInterval: Design.captureInterval, repeats: true) { _ in
            self.capture()
        }
    }
    
    private func capture() {
        let path = folderPath.appendingPathComponent("\(Date().timeIntervalSince1970).png")
        let process = Process()
        process.launchPath = "/usr/sbin/screencapture"
        process.arguments = [
            "-m",
            "-x",
            path.path
        ]
        process.launch()
        print(path)
    }
}
