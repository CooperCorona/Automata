//
//  PDAState.swift
//  Automata
//
//  Created by Cooper Knaak on 10/17/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Represents a state in a Pushdown Automata.
public struct PDAState: State, CustomStringConvertible {
    
    ///The name of this state. Identifies this state to the transition function.
    public let identifier:String
    
    ///The transition edges leading away from this state. The input
    ///is the input character. The output is a PDATransitionInput
    ///instance representing the output state and the necessary
    ///values to pop and push on the stack.
    public private(set) var edges:[String:[PDATransitionInput]] = [:]
    
    ///The input characters in the alphabet of the parent PDA.
    public var transitions: [String] { return self.edges.keys.map() { $0 } }
    
    ///Whether this state is a final state or not. If a string, when run
    ///through a PDA, ends on a final state, it is accepted.
    public let isFinal:Bool
    
    public var description: String {
        var desc = "\(self.identifier)"
        if self.isFinal {
            desc += " (Final)"
        }
        desc += ":"
        for (input, outputs) in self.edges {
            for output in outputs {
                desc += " \(input),\(output.pop)->\(output.push)=\(output.output)"
            }
        }
        return desc
    }
    
    ///Initializes a PDAState with a given identifier.
    ///- parameter identifier: The name of this state. Used by other
    ///states to identify outputs of transition functions.
    public init(identifier:String, isFinal:Bool = false) {
        self.identifier = identifier
        self.isFinal = isFinal
    }
    
    ///Adds an edge from this state to the given state.
    ///- parameter edge: The input character necessary for transitioning.
    ///- parameter pop: The character on top of the stack that must be popped to transition.
    ///- parameter push: The character that is pushed on the stack when the state is transitioned.
    ///- parameter state: The state to transition to for the given input.
    public mutating func add(edge:String, pop:String, push:String, to state:String) {
        let input = PDATransitionInput(output: state, pop: pop, push: push)
        if self.edges[edge] == nil {
            self.edges[edge] = [input]
        } else {
            self.edges[edge]?.append(input)
        }
    }
    
}
