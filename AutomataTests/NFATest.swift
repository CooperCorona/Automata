//
//  NFATest.swift
//  AutomataTests
//
//  Created by Cooper Knaak on 10/10/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import XCTest
import Automata

class NFATest: AutomataTestCase {

    ///Tests an NFA that accepts the language of strings
    ///over alphabet {a, b} containing the substring "aa" or "aba".
    func testNFA1() {
        let lines = self.getLines("""
            0: a=0 b=0 a=1
            1: b=2 \\epsilon=2
            2: a=3
            3 (Final): a=3 b=3
        """)
        do {
            let automata = try AutomataParser().parseNFA(lines: lines)
            self.test(automata: automata, testCases: [
                ("", false),
                ("a", false),
                ("b", false),
                ("aa", true),
                ("ab", false),
                ("ba", false),
                ("bb", false),
                ("aaa", true),
                ("baa", true),
                ("aba", true),
                ("aab", true),
                ("bba", false),
                ("bab", false),
                ("abb", false),
                ("bbb", false),
            ])
        } catch {
            XCTAssert(false, "Failed to parse automata")
        }
    }

    ///Tests an NFA that accepts the language of strings over
    ///alphabet {a, b} which contains a pair of ones with a
    ///positive even number of characters separating them.
    func testNFA2() {
        let lines = self.getLines("""
            a: 0=a 1=a 1=b
            b: 0=c 1=c
            c: 0=d 1=d
            d: 1=e \\epsilon=b
            e (Final): 0=e 1=e
        """)
        do {
            let automata = try AutomataParser().parseNFA(lines: lines)
            self.test(automata: automata, testCases: [
                ("", false),
                
                ("1", false),
                ("0", false),
                
                ("00", false),
                ("10", false),
                ("01", false),
                ("11", false),
                
                ("000", false),
                ("100", false),
                ("010", false),
                ("001", false),
                ("110", false),
                ("101", false),
                ("011", false),
                ("111", false),
                
                ("0000", false),
                ("1000", false),
                ("0100", false),
                ("0010", false),
                ("0001", false),
                ("1100", false),
                ("1010", false),
                ("1001", true),
                ("0110", false),
                ("0101", false),
                ("0011", false),
                ("1110", false),
                ("1011", true),
                ("1101", true),
                ("0111", false),
                ("1111", true),
                
                ("010010", true),
                ("010110", true),
                ("0110010", true),
                ("10011001", true)
            ])
        } catch {
            XCTAssert(false, "Failed to parse automata.")
        }
    }
    
}
