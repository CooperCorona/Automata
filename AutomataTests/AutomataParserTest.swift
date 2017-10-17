//
//  AutomataParserTest.swift
//  AutomataTests
//
//  Created by Cooper Knaak on 10/9/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import XCTest
import Automata

class AutomataParserTest: AutomataTestCase {

    ///Tests whether an AutoamtaParser properly parses a string
    ///representing a DFA.
    func testDFA1() {
        let lines = self.getLines("""
            A: 0=A 1=B
            B: 1=B 0=C
            C (Final): 0=C 1=A
        """)
        do {
            let parser = AutomataParser()
            let automata = try parser.parseDFA(lines: lines)
            XCTAssert(automata.states["A"] != nil)
            XCTAssert(automata.states["A"]!.identifier == "A")
            XCTAssert(automata.states["A"]!.edges == ["0": "A", "1": "B"])
            XCTAssert(automata.states["B"] != nil)
            XCTAssert(automata.states["B"]!.identifier == "B")
            XCTAssert(automata.states["B"]!.edges == ["1": "B", "0": "C"])
            XCTAssert(automata.states["C"] != nil)
            XCTAssert(automata.states["C"]!.identifier == "C")
            XCTAssert(automata.states["C"]!.edges == ["0": "C", "1": "A"])
            XCTAssert(true)
        } catch {
            //Should have parsed, fail to parse.
            XCTAssert(false)
        }
    }
    
    ///Tests whether an AutoamtaParser properly parses a string
    ///representing a NFA.
    func testNFA1() {
        let lines = self.getLines("""
            A: 1=B
            B: 0=C
            C (Final): 1=A
        """)
        do {
            let parser = AutomataParser()
            let automata = try parser.parseNFA(lines: lines)
            XCTAssert(automata.states["A"] != nil)
            XCTAssert(automata.states["A"]!.identifier == "A")
            XCTAssert(automata.states["A"]!.edges["0"] == nil)
            XCTAssert(automata.states["A"]!.edges["1"]! == ["B"])
            XCTAssert(automata.states["B"] != nil)
            XCTAssert(automata.states["B"]!.identifier == "B")
            XCTAssert(automata.states["B"]!.edges["1"] == nil)
            XCTAssert(automata.states["B"]!.edges["0"]! == ["C"])
            XCTAssert(automata.states["C"] != nil)
            XCTAssert(automata.states["C"]!.identifier == "C")
            XCTAssert(automata.states["C"]!.edges["0"] == nil)
            XCTAssert(automata.states["C"]!.edges["1"]! == ["A"])
            XCTAssert(true)
        } catch {
            //Should have parsed, fail to parse.
            XCTAssert(false)
        }
    }
    
}
