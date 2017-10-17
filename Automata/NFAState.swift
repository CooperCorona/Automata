//
//  NFAState.swift
//  Automata
//
//  Created by Cooper Knaak on 10/6/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Represents a state in a nondeterministic finite automata.
///NFA states can have any non-negative number of edges per
///character in the alphabet. NFA states can have epsilon
///transitions, in which no input character is necessary
///to transition to the next state. An epsilon transition
///is represented by "" or "\epsilon".
public struct NFAState: State, CustomStringConvertible {
    
    ///The name of this state. Used to identify
    ///transitions.
    public let identifier:String
    
    ///A dictionary mapping edges (input characters) to
    ///states.
    public private(set) var edges:[String:[String]] = [:]
    ///Whether this state is a final state or not.
    public let isFinal:Bool
    
    public var description: String {
        var desc = "\(self.identifier)"
        if self.isFinal {
            desc += " (Final)"
        }
        desc += ":"
        for (input, output) in self.edges {
            if input == "" {
                desc += " \\epsilon=\(output)"
            } else {
                desc += " \(input)=\(output)"
            }
        }
        return desc
    }
    
    ///The input transitions for this state.
    public var transitions: [String] {
        return self.edges.keys.map() { $0 }
    }
    
    public init(identifier:String, isFinal:Bool = false) {
        self.identifier = identifier
        self.isFinal = isFinal
    }
    
    ///Adds a transition from this state to a given state for a given edge.
    ///- parameter edge: The input character for this transition.
    ///- parameter state: The output state for the given input.
    public mutating func add(edge:String, to state:String) {
        if self.edges[edge] == nil {
            self.edges[edge] = [state]
        } else {
            self.edges[edge]?.append(state)
        }
    }
    
}
