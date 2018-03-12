//
//  DFAComparer.swift
//  Automata
//
//  Created by Cooper Knaak on 3/12/18.
//  Copyright © 2018 CooperCorona. All rights reserved.
//

import Foundation

public class DFAComparer {
    
    private let minimized1:DFA
    private let minimized2:DFA
    private var stateMap:[DFAState:DFAState] = [:]
    private var stateQueue:[DFAState] = []
    
    public init(dfa1:DFA, dfa2:DFA) {
        let minimizer = DFAMinimizer()
        self.minimized1 = minimizer.minimize(dfa: dfa1)
        self.minimized2 = minimizer.minimize(dfa: dfa2)
    }
    
    public func areEqual() -> Bool {
        guard self.minimized1.states.count == self.minimized2.states.count else {
            return false
        }
        guard let initial1 = self.minimized1.initialState, let initial2 = self.minimized2.initialState else {
            return false
        }
        self.stateMap = [initial1:initial2]
        self.stateQueue = [initial1]
        while let currentState = stateQueue.first {
            self.stateQueue.removeFirst()
            guard self.iterate(state: currentState) else {
                return false
            }
        }
        return true
    }
    
    private func iterate(state:DFAState) -> Bool {
        if let mappedState = self.stateMap[state] {
            
        } else {
            
        }
//        for (input, output) in state.edges {
//            guard let outputState = self.minimized1.states[output] else {
//                return false
//            }
//        }
    }
    
    private func compare(state1:DFAState, state2:DFAState) -> Bool {
        
    }
    
}
