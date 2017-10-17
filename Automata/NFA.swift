//
//  NFA.swift
//  Automata
//
//  Created by Cooper Knaak on 10/6/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Represents a non-deterministic finite automata.
public struct NFA: Automata {
    
    ///Unicode for the Greek letter epsilon.
    private static let epsilon = "\u{03B5}"
    
    ///The states comprising the automata. The key is
    ///the identifier of the state.
    public let states:[String:NFAState]
    ///The initial state of the automata.
    public let initialState:NFAState?
    
    public var description: String {
        return self.states.values.sorted() { (a:NFAState, b:NFAState) -> Bool in
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
        guard let currentState = self.initialState else {
            return false
        }
        var currentStates = [currentState] + NFA.epsilon(states: self.states, for: currentState, recursive: true)
        for input in string {
            currentStates = currentStates.flatMap() { (state:NFAState) -> [NFAState] in
                let nextStates = self.next(state: state, for: "\(input)")
                let epsilonStates = nextStates.flatMap() { NFA.epsilon(states: self.states, for: $0, recursive: true) }
                return nextStates + epsilonStates
            }
        }
        return currentStates.reduce(false) { $0 || $1.isFinal }
    }
    
    ///Initializes a DFA with an array of states.
    public init(states:[NFAState]) {
        self.initialState = states.first
        self.states = [String:NFAState](uniqueKeysWithValues: states.map() { ($0.identifier, $0) })
    }
    
    ///Gets the output state for the transition input of a given state.
    ///- parameter state: The current state.
    ///- parameter edge: The input.
    ///- returns: The output state for the transition of the current state
    ///with the given input, or nil if no output exists.
    private func next(state:NFAState, for edge:String) -> [NFAState] {
        guard let output = state.edges[edge] else {
            return []
        }
        return output.flatMap() { self.states[$0] }
    }
    
    ///Returns all states accessible from the given state without
    ///an input character (all states accessible via epsilon transitions).
    ///- parameter state: The current state.
    ///- parameter recursive: Whether to access the epsilon transitions
    ///of the output states, recursively.
    public static func epsilon(states:[String:NFAState], for state:NFAState, recursive:Bool) -> [NFAState] {
        let emptyString = state.edges[""]?.flatMap() { states[$0] } ?? []
        let epsilonString = state.edges["\\epsilon"]?.flatMap() { states[$0] } ?? []
        let unicodeEpsilonString = state.edges[NFA.epsilon]?.flatMap() { states[$0] } ?? []
        let epsilonStates = emptyString + epsilonString + unicodeEpsilonString
        if recursive {
            return epsilonStates + epsilonStates.flatMap() { NFA.epsilon(states: states, for: $0, recursive: recursive) }
        } else {
            return epsilonStates
        }
    }
}
