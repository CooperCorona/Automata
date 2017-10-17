//
//  AutomataTestCase.swift
//  AutomataTests
//
//  Created by Cooper Knaak on 10/9/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import XCTest
import Cocoa
import Automata

class AutomataTestCase: XCTestCase {
    
    func getLines(_ string:String) -> [String] {
        return string.components(separatedBy: "\n").map() { $0.trim() } .filter() { $0 != "" }
    }
    
    func test(automata:Automata, testCases:[(String, Bool)]) {
        do {
            for (input, expected) in testCases {
                let didAccept = try automata.accepts(string: input)
                XCTAssertEqual(expected, didAccept, "\"\(input)\" | Expected: \(expected) | Output: \(didAccept)")
            }
        } catch {
            XCTAssert(false)
        }
    }
    
}
