//
//  PDATest.swift
//  AutomataTests
//
//  Created by Cooper Knaak on 10/20/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import XCTest
import Automata

class PDATest: AutomataTestCase {

    ///Tests a PDA that recognizes the language of strings over alphabet
    ///{a, b} of the form { a^m b^n | m > n >= 1 }.
    func testPDA1() {
        let lines = self.getLines("""
            1: \\epsilon,\\epsilon->$=2
            2: a,\\epsilon->A=2 b,A->\\epsilon=3
            3: b,A->\\epsilon=3 \\epsilon,A->\\epsilon=4
            4 (Final):
        """)
        do {
            let parser = AutomataParser()
            let automata = try parser.parsePDA(lines: lines)
            self.test(automata: automata, testCases: [("aab", true)])
            self.test(automata: automata, testCases: [
                ("", false),
                
                ("a", false),
                ("b", false),
                
                ("aa", false),
                ("ab", false),
                ("ba", false),
                ("bb", false),
                
                ("aaa", false),
                ("baa", false),
                ("aba", false),
                ("aab", true),
                ("bba", false),
                ("bab", false),
                ("abb", false),
                ("bbb", false),
                
                ("aaaa", false),
                ("baaa", false),
                ("abaa", false),
                ("aaba", false),
                ("aaab", true),
                ("bbaa", false),
                ("baba", false),
                ("baab", false),
                ("abba", false),
                ("abab", false),
                ("aabb", false),
                ("bbba", false),
                ("babb", false),
                ("bbab", false),
                ("abbb", false),
                ("bbbb", false),
                
                ("aaaab", true),
                ("aaaabb", true),
                ("aaaabbb", true),
            ])
        } catch {
            XCTAssert(false, "Failed to parse automata.")
        }
    }

}
