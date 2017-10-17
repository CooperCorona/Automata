//
//  DFATest.swift
//  AutomataTests
//
//  Created by Cooper Knaak on 10/9/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import XCTest
import Automata

class DFATest: AutomataTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///Tests a DFA that recognizes the language of all strings
    ///over alphabet {0, 1} with substring "10".
    func testDFA1() {
        let lines = self.getLines("""
            A: 0=A 1=B
            B: 0=C 1=B
            C (Final): 0=C 1=C
        """)
        do {
            let automata = try AutomataParser().parseDFA(lines: lines)
            self.test(automata: automata, testCases: [
                ("", false),
                ("1", false),
                ("0", false),
                ("10", true),
                ("01", false),
                ("100", true),
                ("010", true),
                ("001", false),
                ("110", true),
                ("101", true),
                ("011", false),
                ("111", false),
            ])
        } catch {
            XCTAssert(false)
        }
    }
    
    ///Tests a DFA that recognzies the langauge of all strings
    ///over alphabet {0, 1} whose binary representation is divisible by 3.
    ///For the purposes of this test the empty string is considered 0.
    func testDFA2() {
        let lines = self.getLines("""
            0 (Final): 0=0 1=1
            1: 0=2 1=0
            2: 0=1 1=2
        """)
        do {
            let automata = try AutomataParser().parseDFA(lines: lines)
            self.test(automata: automata, testCases: [
                ("", true),
                ("0", true),
                ("1", false),
                ("00", true),
                ("10", false),
                ("01", false),
                ("11", true),
                ("000", true),
                ("100", false),
                ("010", false),
                ("001", false),
                ("110", true),
                ("101", false),
                ("011", true),
                ("111", false)
            ])
        } catch {
            XCTAssert(false, "Automata failed to parse.")
        }
    }

}
