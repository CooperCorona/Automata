//
//  DFA.swift
//  Automata
//
//  Created by Cooper Knaak on 10/6/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Represents a deterministic finite automata.
public struct DFA: Automata, CustomStringConvertible {
    
    ///The states comprising the automata. The key is
    ///the identifier of the state.
    public let states:[String:DFAState]
    ///The initial state of the automata.
    public let initialState:DFAState?
    
    public var description: String {
        return self.states.values.sorted() { (a:DFAState, b:DFAState) -> Bool in
            if a.identifier == self.initialState?.identifier {
                return true
            } else if b.identifier == self.initialState?.identifier {
                return false
            } else {
                return a.identifier < b.identifier
            }
        } .map() { "\($0)" } .joined(separator: "\n")
    }
    
    ///Returns true if this automata accepts a given input string, false otherwise.
    ///If a character in the input string is outside this object's alphabet,
    ///throws AutomataError.CharacterNotInAlphabet.
    ///- parameter string: An input string.
    public func accepts(string:String) throws -> Bool {
        guard var currentState = self.initialState else {
            return false
        }
        for input in string {
            //DFAs only have edges to one other state, so
            //the array doesn't matter, just the first element.
            guard let next = self.next(state: currentState, for: "\(input)") else {
                throw AutomataError.CharacterNotInAlphabet("\(input)")
            }
            currentState = next
        }
        return currentState.isFinal
    }
    
    ///Initializes a DFA with an array of states.
    public init(states:[DFAState]) {
        self.initialState = states.first
        self.states = [String:DFAState](uniqueKeysWithValues: states.map() { ($0.identifier, $0) })
    }
    
    ///Gets the output state for the transition input of a given state.
    ///- parameter state: The current state.
    ///- parameter edge: The input.
    ///- returns: The output state for the transition of the current state
    ///with the given input, or nil if no output exists.
    private func next(state:DFAState, for edge:String) -> DFAState? {
        guard let output = state.edges[edge] else {
            return nil
        }
        return self.states[output]
    }
}
