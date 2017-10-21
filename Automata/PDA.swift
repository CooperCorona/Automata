//
//  PDA.swift
//  Automata
//
//  Created by Cooper Knaak on 10/17/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation
import CoronaConvenience

///Represents a Pushdown Automata. A pushdown automata is like an NFA,
///except in addition to reading input symbols, it also keeps track of
///a stack. Certain transition edges may only be accessed if the top
///of the stack contains the correct symbol (which is then popped). A
///PDA is equivalent to a context free grammar.
public struct PDA: Automata, CustomStringConvertible {
    
    ///Represents the current state a PDA is on when trying to
    ///determine if a given string is accepted. Like an NFA, a
    ///PDA has multiple potential branches that might have different
    ///stacks associated with them, so the stack must be stored, too.
    private struct CurrentState: CustomStringConvertible {
        ///The state the PDA is currently on.
        var state:PDAState
        ///The value of the stack at the current state.
        var stack:[String]
        
        var description: String { return "\(self.state.identifier) - \(self.stack)" }
    }
    
    ///The states comprising the automata. The key is
    ///the identifier of the state.
    public let states:[String:PDAState]
    ///The initial state of the automata.
    public let initialState:PDAState?
    
    public var description: String {
        return self.states.values.sorted() { (a:PDAState, b:PDAState) -> Bool in
            if a.identifier == self.initialState?.identifier {
                return true
            } else if b.identifier == self.initialState?.identifier {
                return false
            } else {
                return a.identifier < b.identifier
            }
        } .map() { "\($0)" } .joined(separator: "\n")
    }
    
    ///Initializes a PDA with the given states.
    ///- parameter states: The states of the PDA. The first state is assumed to be the start state.
    public init(states:[PDAState]) {
        self.initialState = states.first
        self.states = [String:PDAState](uniqueKeysWithValues: states.map() { ($0.identifier, $0) })
    }
    
    public func accepts(string: String) throws -> Bool {
        guard let initialState = self.initialState else {
            return false
        }
        var currentStates = [CurrentState(state: initialState, stack: [])]
        currentStates += self.epsilonStates(for: currentStates[0], recursive: true)
        for inputChar in string {
            let input = "\(inputChar)"
            currentStates = currentStates.flatMap() { (currentState:CurrentState) -> [CurrentState] in
                let nextStates = self.next(state: currentState, for: input, stack: currentState.stack)
                let epsilonStates = nextStates.flatMap() { self.epsilonStates(for: $0, recursive: true) }
                return nextStates + epsilonStates
            }
        }
        return currentStates.reduce(false) { $0 || $1.state.isFinal }
    }
    
    private func next(state:CurrentState, for input:String, stack:[String]) -> [CurrentState] {
        guard let nextStates = state.state.edges[input] else {
            return []
        }
        return nextStates.filter() { self.isValid(state: $0, for: stack) } .map() { (currentState:PDATransitionInput) -> CurrentState in
            var nextStack = stack
            if !NFA.isEpsilon(currentState.pop) {
                let _ = nextStack.popLast()
            }
            if !NFA.isEpsilon(currentState.push) {
                nextStack.append(currentState.push)
            }
            return CurrentState(state: self.states[currentState.output]!, stack: nextStack)
        }
    }
    
    private func isValid(state:PDATransitionInput, for stack:[String]) -> Bool {
        return NFA.isEpsilon(state.pop) || state.pop == stack.last
    }
    
    private func epsilonStates(for state:CurrentState, recursive:Bool = true) -> [CurrentState] {
        let epsilonStates = state.state.edges.get(keys: NFA.epsilons).flatMap() { $0 } .filter() {
            self.isValid(state: $0, for: state.stack)
        } .map() { (currentState:PDATransitionInput) -> CurrentState in
            var nextStack = state.stack
            if !NFA.isEpsilon(currentState.pop) {
                let _ = nextStack.popLast()
            }
            if !NFA.isEpsilon(currentState.push) {
                nextStack.append(currentState.push)
            }
            return CurrentState(state: self.states[currentState.output]!, stack: nextStack)
        }
        if recursive {
            return epsilonStates + epsilonStates.flatMap() { self.epsilonStates(for: $0, recursive: recursive) }
        } else {
            return epsilonStates
        }
    }
}
