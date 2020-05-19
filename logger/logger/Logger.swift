//
//  Logger.swift
//  logger
//
//  Created by Andrew Finke on 5/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import IOKit.hid

class Logger {
    
    // MARK: - Properties -
    
    static let current = Logger()
    
    private let keyProcessing = KeyProcessing()
    private let clickProcessing = ClickProcessing()
    private let screenProcessing = ScreenProcessing()
    
    private let writeTimer: DispatchSourceTimer
    private let processingQueue = DispatchQueue(label: "com.andrewfinke.logger.processing", qos: .background)
    
    private lazy var manager: IOHIDManager = {
        return IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    }()
    
    // MARK: - Initalization -

    init() {
        writeTimer = DispatchSource.makeTimerSource(queue: processingQueue)
        writeTimer.schedule(
            deadline: .now(),
            repeating: .seconds(Design.writeInterval),
            leeway: .seconds(5))
        writeTimer.setEventHandler {
            self.keyProcessing.write()
            self.clickProcessing.write()
        }
        writeTimer.resume()
        
        func device(for page: Int, usage: Int) -> CFDictionary {
            return [
                kIOHIDDeviceUsagePageKey: page,
                kIOHIDDeviceUsageKey: usage
                ] as CFDictionary
        }
        
        let matchingMultiple = [
            device(for: kHIDPage_GenericDesktop, usage: kHIDUsage_GD_Keyboard),
            device(for: kHIDPage_GenericDesktop, usage: kHIDUsage_GD_Keypad),
            device(for: kHIDPage_GenericDesktop, usage: kHIDUsage_GD_Mouse)
            ] as CFArray
        
        IOHIDManagerSetDeviceMatchingMultiple(manager, matchingMultiple)
        guard let devices = IOHIDManagerCopyDevices(manager) else { fatalError() }
        
        for deviceElement in devices as NSSet {
            guard CFGetTypeID(deviceElement as CFTypeRef) == IOHIDDeviceGetTypeID() else { fatalError() }
            let device = deviceElement as! IOHIDDevice
            
            let isMouse: Bool
            let filters: CFDictionary
            
            if device.conforms(toPage: kHIDPage_GenericDesktop, usage: kHIDUsage_GD_Keyboard) ||
                device.conforms(toPage: kHIDPage_GenericDesktop, usage: kHIDUsage_GD_Keypad) {
                isMouse = false
                filters = [
                    kIOHIDElementUsageMinKey: 4,
                    kIOHIDElementUsageMaxKey: 231
                    ] as CFDictionary
            } else if device.conforms(toPage: kHIDPage_GenericDesktop, usage: kHIDUsage_GD_Mouse) {
                isMouse = true
                filters = [
                    kIOHIDElementUsageMinKey: 1,
                    kIOHIDElementUsageMaxKey: 1
                    ] as CFDictionary
            } else {
                fatalError()
            }
            IOHIDDeviceSetInputValueMatching(device, filters)
            
            if isMouse {
                IOHIDDeviceRegisterInputValueCallback(device, { context, result, sender, value in
                    Logger.current.mouseInputValueCallback(
                        context: context,
                        result: result,
                        sender: sender,
                        value: value)
                    
                }, nil)
            } else {
                IOHIDDeviceRegisterInputValueCallback(device, { context, result, sender, value in
                    Logger.current.keyboardInputValueCallback(
                        context: context,
                        result: result,
                        sender: sender,
                        value: value)
                    
                }, nil)
            }
        }
        
        IOHIDManagerRegisterDeviceMatchingCallback( manager, { context, result, sender, device in
            Logger.current.deviceMatchingCallback(
                context: context,
                result: result,
                sender: sender,
                device: device)
        }, nil)
        IOHIDManagerRegisterDeviceRemovalCallback(manager, { context, result, sender, device in
            Logger.current.deviceRemovalCallback(
                context: context,
                result: result,
                sender: sender,
                device: device)
        }, nil)
        
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        let ret = IOHIDManagerOpen(manager, 0);
        guard ret == kIOReturnSuccess else {
            fatalError("ret: \(ret)")
        }
        
        clickProcessing.stats()
        keyProcessing.stats()
    }
    
    // MARK: - Callbacks -
    
    private func deviceMatchingCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, device: IOHIDDevice) {
        let product = device.property(kIOHIDProductKey) ?? "Unknown"
        print(#function + ": \(product)")
    }
    
    private func deviceRemovalCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, device: IOHIDDevice) {
        let product = device.property(kIOHIDProductKey) ?? "Unknown"
        print(#function + ": \(product)")
    }
    
    private func keyboardInputValueCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, value: IOHIDValue) {
        processingQueue.async {
            let element = value.element
            let usage = element.usage
            let isPressed = value.intValue == 1
            self.keyProcessing.state(updated: usage, isPressed: isPressed)
        }
    }
    
    private func mouseInputValueCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, value: IOHIDValue) {
        processingQueue.async {
            if value.element.type == kIOHIDElementTypeInput_Button && value.intValue == 1 {
                self.clickProcessing.clicked()
            }
        }
    }
}
