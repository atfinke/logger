//
//  HIDKeyboardMap.swift
//  logger
//
//  Created by Andrew Finke on 5/18/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

struct HIDKeyboardMap {
    
    // MARK: - Types -
    
    enum Key: Hashable {
        case character(Character)
        case function(Int)
        
        case space
        case `return`
        case tab
        
        case escape
        case delete
        
        case capsLock
        
        case rightArrow
        case leftArrow
        case downArrow
        case upArrow
        
        case leftControl
        case leftShift
        case leftOption
        case leftCommand
        
        case rightControl
        case rightShift
        case rightOption
        case rightCommand
    }
    
    enum ShiftState {
        case none, shift, caps
    }
    
    // MARK: - Properties -
    
    private let map: [UInt32: [ShiftState: Key]]
    
    // MARK: - Initalization -
    
    init() {
        map = [
            0x04: [
                .shift: .character("A"),
                .caps: .character("A"),
                .none: .character("a")
            ],
            0x05: [
                .shift: .character("B"),
                .caps: .character("B"),
                .none: .character("b")
            ],
            0x06: [
                .shift: .character("C"),
                .caps: .character("C"),
                .none: .character("c")
            ],
            0x07: [
                .shift: .character("D"),
                .caps: .character("D"),
                .none: .character("d")
            ],
            0x08: [
                .shift: .character("E"),
                .caps: .character("E"),
                .none: .character("e")
            ],
            0x09: [
                .shift: .character("F"),
                .caps: .character("F"),
                .none: .character("f")
            ],
            0x0A: [
                .shift: .character("G"),
                .caps: .character("G"),
                .none: .character("g")
            ],
            0x0B: [
                .shift: .character("H"),
                .caps: .character("H"),
                .none: .character("h")
            ],
            0x0C: [
                .shift: .character("I"),
                .caps: .character("I"),
                .none: .character("i")
            ],
            0x0D: [
                .shift: .character("J"),
                .caps: .character("J"),
                .none: .character("j")
            ],
            0x0E: [
                .shift: .character("K"),
                .caps: .character("K"),
                .none: .character("k")
            ],
            0x0F: [
                .shift: .character("L"),
                .caps: .character("L"),
                .none: .character("l")
            ],
            0x10: [
                .shift: .character("M"),
                .caps: .character("M"),
                .none: .character("m")
            ],
            0x11: [
                .shift: .character("N"),
                .caps: .character("N"),
                .none: .character("n")
            ],
            0x12: [
                .shift: .character("O"),
                .caps: .character("O"),
                .none: .character("o")
            ],
            0x13: [
                .shift: .character("P"),
                .caps: .character("P"),
                .none: .character("p")
            ],
            0x14: [
                .shift: .character("Q"),
                .caps: .character("Q"),
                .none: .character("q")
            ],
            0x15: [
                .shift: .character("R"),
                .caps: .character("R"),
                .none: .character("r")
            ],
            0x16: [
                .shift: .character("S"),
                .caps: .character("S"),
                .none: .character("s")
            ],
            0x17: [
                .shift: .character("T"),
                .caps: .character("T"),
                .none: .character("t")
            ],
            0x18: [
                .shift: .character("U"),
                .caps: .character("U"),
                .none: .character("u")
            ],
            0x19: [
                .shift: .character("V"),
                .caps: .character("V"),
                .none: .character("v")
            ],
            0x1A: [
                .shift: .character("W"),
                .caps: .character("W"),
                .none: .character("w")
            ],
            0x1B: [
                .shift: .character("X"),
                .caps: .character("X"),
                .none: .character("x")
            ],
            0x1C: [
                .shift: .character("Y"),
                .caps: .character("Y"),
                .none: .character("y")
            ],
            0x1D: [
                .shift: .character("Z"),
                .caps: .character("Z"),
                .none: .character("z")
            ],
            0x1E: [
                .shift: .character("!"),
                .none: .character("1")
            ],
            0x1F: [
                .shift: .character("@"),
                .none: .character("2")
            ],
            0x20: [
                .shift: .character("#"),
                .none: .character("3")
            ],
            0x21: [
                .shift: .character("$"),
                .none: .character("4")
            ],
            0x22: [
                .shift: .character("%"),
                .none: .character("5")
            ],
            0x23: [
                .shift: .character("^"),
                .none: .character("6")
            ],
            0x24: [
                .shift: .character("&"),
                .none: .character("7")
            ],
            0x25: [
                .shift: .character("*"),
                .none: .character("8")
            ],
            0x26: [
                .shift: .character("("),
                .none: .character("9")
            ],
            0x27: [
                .shift: .character(")"),
                .none: .character("0")
            ],
            0x28: [
                .shift: .return,
                .none: .return
            ],
            0x29: [
                .shift: .escape,
                .none: .escape
            ],
            0x2A: [
                .shift: .delete,
                .none: .delete
            ],
            0x2B: [
                .shift: .tab,
                .none: .tab
            ],
            0x2C: [
                .shift: .space,
                .none: .space
            ],
            0x2D: [
                .shift: .character("_"),
                .none: .character("-")
            ],
            0x2E: [
                .shift: .character("+"),
                .none: .character("=")
            ],
            0x2F: [
                .shift: .character("{"),
                .none: .character("[")
            ],
            0x30: [
                .shift: .character("}"),
                .none: .character("]")
            ],
            0x31: [
                .shift: .character("|"),
                .none: .character("\\")
            ],
            //0x32 Keyboard Non-US # and ~
            0x33: [
                .shift: .character(":"),
                .none: .character(";")
            ],
            0x34: [
                .shift: .character("\""),
                .none: .character("'")
            ],
            0x35: [
                .shift: .character("~"),
                .none: .character("`")
            ],
            0x36: [
                .shift: .character("<"),
                .none: .character(",")
            ],
            0x37: [
                .shift: .character(">"),
                .none: .character(".")
            ],
            0x38: [
                .shift: .character("?"),
                .none: .character("/")
            ],
            0x39: [
                .shift: .capsLock,
                .none: .capsLock,
            ],
            
            0x3A: [
                .shift: .function(1),
                .none: .function(1)
            ],
            0x3B: [
                .shift: .function(2),
                .none: .function(2)
            ],
            0x3C: [
                .shift: .function(3),
                .none: .function(3)
            ],
            0x3D: [
                .shift: .function(4),
                .none: .function(4)
            ],
            0x3E: [
                .shift: .function(5),
                .none: .function(5)
            ],
            0x3F: [
                .shift: .function(6),
                .none: .function(6)
            ],
            0x40: [
                .shift: .function(7),
                .none: .function(7)
            ],
            0x41: [
                .shift: .function(8),
                .none: .function(8)
            ],
            0x42: [
                .shift: .function(9),
                .none: .function(9)
            ],
            0x43: [
                .shift: .function(10),
                .none: .function(10)
            ],
            0x44: [
                .shift: .function(11),
                .none: .function(11)
            ],
            0x45: [
                .shift: .function(12),
                .none: .function(12)
            ],
            0x4F: [
                .shift: .rightArrow,
                .none: .rightArrow
            ],
            0x50: [
                .shift: .leftArrow,
                .none: .leftArrow
            ],
            0x51: [
                .shift: .downArrow,
                .none: .downArrow
            ],
            0x52: [
                .shift: .upArrow,
                .none: .upArrow
            ],
            0x54: [
                .shift: .character("/"),
                .none: .character("/")
            ],
            0x55: [
                .shift: .character("*"),
                .none: .character("*")
            ],
            0x56: [
                .shift: .character("-"),
                .none: .character("-")
            ],
            0x57: [
                .shift: .character("+"),
                .none: .character("+")
            ],
            0x58: [
                .shift: .return,
                .none: .return
            ],
            0x59: [
                .shift: .character("1"),
                .none: .character("1")
            ],
            0x5A: [
                .shift: .character("2"),
                .none: .character("2")
            ],
            0x5B: [
                .shift: .character("3"),
                .none: .character("3")
            ],
            0x5C: [
                .shift: .character("4"),
                .none: .character("4")
            ],
            0x5D: [
                .shift: .character("5"),
                .none: .character("5")
            ],
            0x5E: [
                .shift: .character("6"),
                .none: .character("6")
            ],
            0x5F: [
                .shift: .character("7"),
                .none: .character("7")
            ],
            0x60: [
                .shift: .character("8"),
                .none: .character("8")
            ],
            0x61: [
                .shift: .character("9"),
                .none: .character("9")
            ],
            0x62: [
                .shift: .character("0"),
                .none: .character("0")
            ],
            0x63: [
                .shift: .character("."),
                .none: .character(".")
            ],
            0xE0: [
                .shift: .leftControl,
                .none: .leftControl
            ],
            0xE1: [
                .shift: .leftShift,
                .none: .leftShift
            ],
            0xE2: [
                .shift: .leftOption,
                .none: .leftOption
            ],
            0xE3: [
                .shift: .leftCommand,
                .none: .leftCommand
            ],
            0xE4: [
                .shift: .rightControl,
                .none: .rightControl
            ],
            0xE5: [
                .shift: .rightShift,
                .none: .rightShift
            ],
            0xE6: [
                .shift: .rightOption,
                .none: .rightOption
            ],
            0xE7: [
                .shift: .rightCommand,
                .none: .rightCommand
            ]
        ]
    }
    
    // MARK: - Helpers -
    
    func key(for code: UInt32, shiftState: ShiftState) -> Key? {
        if shiftState == .caps {
            return map[code]?[shiftState] ?? map[code]?[.none]
        } else {
            return map[code]?[shiftState]
        }
    }
    
}
