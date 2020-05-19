//
//  KeyProcessing.swift
//  logger
//
//  Created by Andrew Finke on 5/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class KeyProcessing {
    
    // MARK: - Properties -
    
    private static let keysKey = "KeyProcessingKeys"
    private static let wordsKey = "KeyProcessingWords"
    private static let commandsKey = "KeyProcessingCommands"
    
    private let keyboardMap = HIDKeyboardMap()
    
    private var keysToWrite = [String: Int]()
    private var wordsToWrite = [String: Int]()
    private var commandsToWrite = [String: Int]()
    
    private var activeWord = [Character]()
    
    private var shiftState: HIDKeyboardMap.ShiftState = .none
    private var modifierKeyStates = Set<HIDKeyboardMap.Key>() {
        didSet {
            if modifierKeyStates.contains(.leftShift) || modifierKeyStates.contains(.rightShift) {
                shiftState = .shift
            } else if modifierKeyStates.contains(.capsLock) {
                shiftState = .caps
            } else {
                shiftState = .none
            }
        }
    }
    
    // MARK: - Helpers -
    
    func state(updated code: UInt32, isPressed: Bool) {
        guard let key = keyboardMap.key(for: code, shiftState: shiftState) else {
            fatalError(code.description)
        }
        let dKey: String
        switch key {
        case .character(let c):
            dKey = "d: \(c)"
            if isPressed && !processShortcut(character: c) {
                if c == "." || c == "?" || c == "!" {
                    finishedWord()
                } else {
                    activeWord.append(c)
                }
            }
        case .function(let i):
            dKey = "f: \(i)"
        case .return:
            dKey = "return"
            if isPressed {
                finishedWord()
            }
        case .tab:
            dKey = "tab"
            if isPressed {
                finishedWord()
            }
        case .space:
            dKey = "space"
            if isPressed {
                finishedWord()
            }
        case .escape:
            dKey = "escape"
            if isPressed {
                finishedWord()
            }
        case .delete:
            dKey = "delete"
            if isPressed && !activeWord.isEmpty{
                activeWord.removeLast()
            }
        case .capsLock:
            dKey = "capsLock"
            if isPressed {
                if modifierKeyStates.contains(.capsLock) {
                    modifierKeyStates.remove(.capsLock)
                } else {
                    modifierKeyStates.insert(.capsLock)
                }
            }
        case .rightArrow:
            dKey = "rightArrow"
            if isPressed {
                finishedWord()
            }
        case .leftArrow:
            dKey = "leftArrow"
            if isPressed {
                finishedWord()
            }
        case .downArrow:
            dKey = "downArrow"
            if isPressed {
                finishedWord()
            }
        case .upArrow:
            dKey = "upArrow"
            if isPressed {
                finishedWord()
            }
        case .leftControl:
            dKey = "leftControl"
            update(modifier: key, isActive: isPressed)
        case .leftShift:
            dKey = "leftShift"
            update(modifier: key, isActive: isPressed)
        case .leftOption:
            dKey = "leftOption"
            update(modifier: key, isActive: isPressed)
        case .leftCommand:
            dKey = "leftCommand"
            update(modifier: key, isActive: isPressed)
        case .rightControl:
            dKey = "rightControl"
            update(modifier: key, isActive: isPressed)
        case .rightShift:
            dKey = "rightShift"
            update(modifier: key, isActive: isPressed)
        case .rightOption:
            dKey = "rightOption"
            update(modifier: key, isActive: isPressed)
        case .rightCommand:
            dKey = "rightCommand"
            update(modifier: key, isActive: isPressed)
        }
        
        if isPressed {
            keysToWrite[dKey, default: 0] += 1
        }
    }
    
    private func update(modifier: HIDKeyboardMap.Key, isActive: Bool) {
        if isActive {
            modifierKeyStates.insert(modifier)
        } else {
            modifierKeyStates.remove(modifier)
        }
    }
    
    // MARK: - Word Processing -
    
    func clicked() {
        finishedWord()
    }
    
    private func finishedWord() {
        let word = String(activeWord).lowercased()
        wordsToWrite[word, default: 0] += 1
        activeWord.removeAll()
        print("\(word): \(wordsToWrite[word, default: 0])")
    }
    
    // MARK: - Shortcut Processing -
    
    private func processShortcut(character: Character) -> Bool {
        let isControl = modifierKeyStates.contains(.leftControl) || modifierKeyStates.contains(.rightControl)
        let isOption = modifierKeyStates.contains(.leftOption) || modifierKeyStates.contains(.rightOption)
        let isShift = modifierKeyStates.contains(.leftShift) || modifierKeyStates.contains(.rightShift)
        let isCommand = modifierKeyStates.contains(.leftCommand) || modifierKeyStates.contains(.rightCommand)
        
        if !isControl && !isOption && !isCommand {
            return false
        }
        
        var key = ""
        if isControl {
            key += "⌃"
        }
        if isOption {
            key += "⌥"
        }
        if isShift {
            key += "⇧"
        }
        if isCommand {
            key += "⌘"
        }
        key += character.uppercased()
        commandsToWrite[key, default: 0] += 1
        
        print("\(key): \(commandsToWrite[key, default: 0])")
        
        return false
    }
    
    // MARK: - Save -
    
    func write() {
        if !keysToWrite.isEmpty {
            write(data: keysToWrite, to: KeyProcessing.keysKey)
            keysToWrite.removeAll()
        }
        if !wordsToWrite.isEmpty {
            write(data: wordsToWrite, to: KeyProcessing.wordsKey)
            wordsToWrite.removeAll()
        }
        if !commandsToWrite.isEmpty {
            write(data: commandsToWrite, to: KeyProcessing.commandsKey)
            commandsToWrite.removeAll()
        }
    }
    
    private func write(data: [String: Int], to defaultsKey: String) {
        var disk = UserDefaults.standard.value(forKey: defaultsKey) as? [String: Int] ?? [:]
        for (key, value) in data {
            disk[key, default: 0] += value
        }
        UserDefaults.standard.set(disk, forKey: defaultsKey)
    }
    
    // MARK: - Stats -
    
    func stats() {
        let keys = topItems(key: KeyProcessing.keysKey).prefix(10)
        let words = topItems(key: KeyProcessing.wordsKey).prefix(10)
        let commands = topItems(key: KeyProcessing.commandsKey).prefix(10)
        
        print("\nTop Keys:")
        for (k, v) in keys {
            print("\(k): \(v)")
        }
        print("\nTop Words:")
        for (k, v) in words {
            print("\(k): \(v)")
        }
        print("\nTop Commands:")
        for (k, v) in commands {
            print("\(k): \(v)")
        }
    }
    
    private func topItems(key: String) -> [(String, Int)] {
        let disk = UserDefaults.standard.value(forKey: key) as? [String: Int] ?? [:]
        return disk.sorted(by: { $0.value > $1.value })
    }
    
}
