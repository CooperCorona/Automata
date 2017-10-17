//
//  DFAMinimizerTest.swift
//  AutomataTests
//
//  Created by Cooper Knaak on 10/10/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import XCTest
import Automata

class DFAMinimizerTest: AutomataTestCase {

    ///Test cases for a DFA which recognizes the language over
    ///alphabet {0, 1} of all strings that do not end in "01"
    ///and contain the substring "10".
    lazy var testCases:[(String, Bool)] = [
        ("", false),
        
        ("1", false),
        ("0", false),
        
        ("00", false),
        ("10", true),
        ("01", false),
        ("11", false),
        
        ("000", false),
        ("100", true),
        ("010", true),
        ("001", false),
        ("110", true),
        ("101", false),
        ("011", false),
        ("111", false),
        
        ("0000", false),
        ("1000", true),
        ("0100", true),
        ("0010", true),
        ("0001", false),
        ("1100", true),
        ("1010", true),
        ("1001", false),
        ("0110", true),
        ("0101", false),
        ("0011", false),
        ("1110", true),
        ("1011", true),
        ("1101", false),
        ("0111", false),
        ("1111", false),
    ]
    
    ///Tests a DFA that recognizes the language of strings over
    ///alphabet {0, 1} that do not end in "01" and contain
    ///substring "10".
    func testDFA1() {
        let lines = self.getLines("""
            A: 0=B 1=C
            B: 0=B 1=D
            C: 0=F 1=C
            D: 0=F 1=C
            E (Final): 0=F 1=E
            F (Final): 0=F 1=G
            G: 0=F 1=E
        """)
        do {
            let automata = try AutomataParser().parseDFA(lines: lines)
            self.test(automata: automata, testCases: self.testCases)
        } catch {
            XCTAssert(false, "Failed to parse automata.")
        }
    }

    ///Tests a different DFA that recognizes the language of
    ///strings over alphabet {0, 1} that do not end in "01"
    ///and contain substring "10".
    func testDFA2() {
        let lines = self.getLines("""
            A: 0=A 1=B
            B: 0=C 1=B
            C (Final): 0=C 1=E
            D (Final): 0=C 1=D
            E: 0=C 1=D
        """)
        do {
            let automata = try AutomataParser().parseDFA(lines: lines)
            self.test(automata: automata, testCases: self.testCases)
        } catch {
            XCTAssert(false, "Failed to parse automata.")
        }
    }
    
    ///Tests the minimization of a DFA recognizing the language of strings
    ///over alphabet {0, 1} that do not end in "01" and contain substring "10".
    ///The original DFA is the same as in -testDFA1 and the minimized
    ///DFA should equal the DFA in -testDFA1.
    func testMinimizer1() {
        let lines = self.getLines("""
            A: 0=B 1=C
            B: 0=B 1=D
            C: 0=F 1=C
            D: 0=F 1=C
            E (Final): 0=F 1=E
            F (Final): 0=F 1=G
            G: 0=F 1=E
        """)
        do {
            let automata = try AutomataParser().parseDFA(lines: lines)
            let minimized = DFAMinimizer().minimize(dfa: automata)
            for (input, _) in self.testCases {
                let expected = try automata.accepts(string: input)
                let actual = try minimized.accepts(string: input)
                XCTAssertEqual(expected, actual, "\"\(input)\" | Expected: \(expected) | Actual: \(actual)")
            }
        } catch {
            XCTAssert(false, "Failed to parse automata.")
        }
    }
    
    ///Tests a very simple DFA that recognizes the language of strings
    ///over alphabet {0, 1} with a nonzero number of characters.
    func testMinimizer2() {
        let lines = self.getLines("""
            A: 0=B 1=B
            B (Final): 0=C 1=C
            C (Final): 0=C 1=C
        """)
        let automata = try! AutomataParser().parseDFA(lines: lines)
        let minimized = DFAMinimizer().minimize(dfa: automata)
        for (input, _) in self.testCases {
            let expected = try! automata.accepts(string: input)
            let actual = try! minimized.accepts(string: input)
            XCTAssertEqual(expected, actual, "\"\(input)\" | Expected: \(expected) | Actual: \(actual)")
        }
    }
    
}
