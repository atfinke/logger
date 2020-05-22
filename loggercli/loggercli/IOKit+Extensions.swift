//
//  IOKit+Extensions.swift
//  logger
//
//  Created by Andrew Finke on 5/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import IOKit

extension IOHIDDevice {
    func conforms(toPage usagePage: Int, usage: Int) -> Bool {
        return IOHIDDeviceConformsTo(self, UInt32(usagePage), UInt32(usage))
    }
    
    func property(_ key: String) -> String? {
        return IOHIDDeviceGetProperty(self, key as CFString) as? String
    }
}

extension IOHIDValue {
    var element: IOHIDElement {
        return IOHIDValueGetElement(self)
    }
    var intValue: Int {
        return IOHIDValueGetIntegerValue(self)
    }
}

extension IOHIDElement {
    var type: IOHIDElementType {
        return IOHIDElementGetType(self)
    }
    var usage: UInt32 {
        return IOHIDElementGetUsage(self)
    }
}
