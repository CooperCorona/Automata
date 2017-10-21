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
    
    ///Tests whether an AutomataParser properly parses a string
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
        } catch {
            //Should have parsed, fail to parse.
            XCTAssert(false)
        }
    }
    
    ///Tests whether an AutomataParser properly parses a string
    ///representing a PDA.
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
            
            XCTAssert(automata.states["1"] != nil)
            XCTAssert(automata.states["1"]!.identifier == "1")
            XCTAssert(automata.states["1"]!.edges.count == 1)
            XCTAssert(automata.states["1"]!.edges["\\epsilon"] != nil)
            XCTAssert(automata.states["1"]!.edges["\\epsilon"]!.count == 1)
            XCTAssert(automata.states["1"]!.edges["\\epsilon"]![0].output == "2")
            XCTAssert(automata.states["1"]!.edges["\\epsilon"]![0].pop == "\\epsilon")
            XCTAssert(automata.states["1"]!.edges["\\epsilon"]![0].push == "$")
            
            XCTAssert(automata.states["2"] != nil)
            XCTAssert(automata.states["2"]!.identifier == "2")
            XCTAssert(automata.states["2"]!.edges.count == 2)
            XCTAssert(automata.states["2"]!.edges["a"] != nil)
            XCTAssert(automata.states["2"]!.edges["a"]!.count == 1)
            XCTAssert(automata.states["2"]!.edges["a"]![0].output == "2")
            XCTAssert(automata.states["2"]!.edges["a"]![0].pop == "\\epsilon")
            XCTAssert(automata.states["2"]!.edges["a"]![0].push == "A")
            XCTAssert(automata.states["2"]!.edges["b"] != nil)
            XCTAssert(automata.states["2"]!.edges["b"]!.count == 1)
            XCTAssert(automata.states["2"]!.edges["b"]![0].output == "3")
            XCTAssert(automata.states["2"]!.edges["b"]![0].pop == "A")
            XCTAssert(automata.states["2"]!.edges["b"]![0].push == "\\epsilon")
            
            XCTAssert(automata.states["3"] != nil)
            XCTAssert(automata.states["3"]!.identifier == "3")
            XCTAssert(automata.states["3"]!.edges.count == 2)
            XCTAssert(automata.states["3"]!.edges["b"] != nil)
            XCTAssert(automata.states["3"]!.edges["b"]!.count == 1)
            XCTAssert(automata.states["3"]!.edges["b"]![0].output == "3")
            XCTAssert(automata.states["3"]!.edges["b"]![0].pop == "A")
            XCTAssert(automata.states["3"]!.edges["b"]![0].push == "\\epsilon")
            XCTAssert(automata.states["3"]!.edges["\\epsilon"] != nil)
            XCTAssert(automata.states["3"]!.edges["\\epsilon"]!.count == 1)
            XCTAssert(automata.states["3"]!.edges["\\epsilon"]![0].output == "4")
            XCTAssert(automata.states["3"]!.edges["\\epsilon"]![0].pop == "A")
            XCTAssert(automata.states["3"]!.edges["\\epsilon"]![0].push == "\\epsilon")
            
            XCTAssert(automata.states["4"] != nil)
            XCTAssert(automata.states["4"]!.identifier == "4")
            XCTAssert(automata.states["4"]!.edges.count == 0)
        } catch {
            XCTAssert(false, "Failed to parse automata.")
        }
        
    }
    
    
}
