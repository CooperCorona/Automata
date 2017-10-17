//
//  NFAConverter.swift
//  Automata
//
//  Created by Cooper Knaak on 10/7/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Converts an NFA to an equivalent DFA.
public struct NFAConverter {
    
    ///Represents multiple NFA states combined into
    ///a single DFA state.
    private class CompositeState {
        private(set) var identifiers = Set<String>()
        var combinedIdentifier:String { return self.identifiers.sorted().joined(separator: ",") }
        private(set) var isFinal:Bool = false
        //A composite state is used to create a DFA,
        //which has unique input-edges.
        private(set) var edges:[String:CompositeState] = [:]
        
        init() {
            
        }
        
        init(state:NFAState) {
            self.identifiers.insert(state.identifier)
            self.isFinal = state.isFinal
        }
        
        func combine(with state:NFAState) {
            self.identifiers.insert(state.identifier)
            self.isFinal = self.isFinal || state.isFinal
        }
        
        func add(edge:String, to state:CompositeState) {
            self.edges[edge] = state
        }
    }
    
    ///Converts a given NFA into a corresponding DFA.
    ///- parameter nfa: A nondeterministic finite automata.
    ///- returns: A DFA instance equivalent to the given NFA instance.
    public func toDFA(nfa:NFA) throws -> DFA {
        guard let firstState = nfa.initialState else {
            return DFA(states: [])
        }
        let alphabet = NFAConverter.alphabet(from: nfa.states)
        var currentStates = [CompositeState(state: firstState)]
        while let firstStateIndex = currentStates.index(where: { Set($0.edges.keys) != alphabet }) {
            let state = currentStates[firstStateIndex]
            for edge in alphabet {/*state.edges.keys {*/
                let toIdentifiers = self.walk(edge: edge, for: state.identifiers, in: nfa.states)
                //                print("  \(state.identifiers) | \(edge): \(toIdentifiers)")
                if let toStateIndex = currentStates.index(where: { $0.identifiers == toIdentifiers }) {
                    state.add(edge: edge, to: currentStates[toStateIndex])
                } else if toIdentifiers.count > 0 {
                    let toState = CompositeState()
                    for toIdentifier in toIdentifiers {
                        let toIdentifierState = nfa.states[toIdentifier]!
                        toState.combine(with: toIdentifierState)
                    }
                    state.add(edge: edge, to: toState)
                    currentStates.append(toState)
                }
                //In this case, the NFA doesn't change state on the given
                //input edge, so a DFA should have a self loop.
                if state.edges[edge] == nil {
                    state.add(edge: edge, to: state)
                }
            }
            //            print("\(state.identifiers) | \(state.edges.map() { ($0.0, $0.1.identifiers) })")
        }
        let states = try self.states(from: currentStates)
        return DFA(states: states)
    }
    
    ///Walks to all output states accessible from a set of input states.
    ///- parameter edge: The input character.
    ///- parameter identifiers: A set of identifiers corresponding to current states.
    ///- parameter states: The states of the NFA being converted.
    ///- returns: All output states accessible when transitioning from the input states using the input character.
    private func walk(edge:String, for identifiers:Set<String>, in states:[String:NFAState]) -> Set<String> {
        var toIdentifiers = Set<String>()
        for identifier in identifiers {
            let state = states[identifier]!
            let nextStates = state.edges[edge].flatMap() { $0.flatMap() { states[$0] } } ?? []
            let epsilonStates = nextStates.flatMap() { NFA.epsilon(states: states, for: $0, recursive: true) }
            for nextState in nextStates {
                toIdentifiers.insert(nextState.identifier)
            }
            for epsilonState in epsilonStates {
                toIdentifiers.insert(epsilonState.identifier)
            }
        }
        return toIdentifiers
    }
    
    ///Converts CompositeState objects into DFAState objects.
    ///- parameter compositeStates: An array of CompositeStates representing combined NFA states.
    ///- returns: An array of DFA states equivalent to the given combined NFA states.
    private func states(from compositeStates:[CompositeState]) throws -> [DFAState] {
        var states = compositeStates.map() { DFAState(identifier: $0.combinedIdentifier, isFinal: $0.isFinal) }
        for i in 0..<states.count {
            for (edge, toCompositeState) in compositeStates[i].edges {
                let toStateIndex = states.index() { $0.identifier == toCompositeState.combinedIdentifier }!
                //
                try! states[i].add(edge: edge, to: states[toStateIndex].identifier)
            }
        }
        return states
    }
    
    ///Combines a set of identifiers corresponding to NFA states into a CompositeState.
    ///- parameter identifiers: A set of identifiers corresponding to NFA states.
    ///- parameter states: The NFA states.
    ///- returns: The CompositeState combining multiple NFA states.
    private func compositeState(from identifiers:Set<String>, in states:[String:NFAState]) -> CompositeState {
        let compositeState = CompositeState()
        for identifier in identifiers {
            compositeState.combine(with: states[identifier]!)
        }
        return compositeState
    }
    
    ///Determines the input alphabet for an NFA.
    ///- parameters: The states of an NFA.
    ///- returns: The alphabet corresponding to the NFA transitions.
    public static func alphabet(from states:[String:State]) -> Set<String> {
        var alphabet = Set<String>()
        for (_, state) in states {
            for edge in state.transitions/*edges.keys*/ where edge != "" && edge != "\\epsilon" {
                alphabet.insert(edge)
            }
        }
        return alphabet
    }
}
