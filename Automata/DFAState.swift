//
//  DFAState.swift
//  Automata
//
//  Created by Cooper Knaak on 10/6/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Represents a state in a deterministic finite automata.
///DFA states have exactly one transition for each character in
///the alphabet. DFA states cannot have epsilon transitions.
///
///Despite broad similarities between DFAState and NFAState,
///the crucial difference is in the way edges work, which
///prevents combining the classes. Both make more sense as
///structs than classes, so inheritance is considered a
///suboptimal solution.
public struct DFAState: Hashable, State, CustomStringConvertible {
    
    ///The name of this state. Used to identify
    ///transitions.
    public let identifier:String
    
    ///A dictionary mapping edges (input characters) to
    ///states.
    public private(set) var edges:[String:String] = [:]
    ///Whether this state is a final state or not.
    public let isFinal:Bool
    
    public var hashValue: Int { return self.identifier.hashValue }
    
    ///The input transitions for this state.
    public var transitions: [String] {
        return self.edges.keys.map() { $0 }
    }
    
    public var description: String {
        var desc = "\(self.identifier)"
        if self.isFinal {
            desc += " (Final)"
        }
        desc += ":"
        for (input, output) in self.edges.sorted(by: { $0.key < $1.key }) {
            desc += " \(input)=\(output)"
        }
        return desc
    }
    
    public init(identifier:String, isFinal:Bool = false) {
        self.identifier = identifier
        self.isFinal = isFinal
    }
    
    ///Adds a transition from this state to a given state for a given edge.
    ///Throws AutomataError.DuplicateEdge if an edge already exists for
    ///a given input character.
    ///- parameter edge: The input character for this transition.
    ///- parameter state: The output state for the given input.
    public mutating func add(edge:String, to state:String) throws {
        guard self.edges[edge] == nil else {
            throw AutomataError.DuplicateInput(self.identifier, edge)
        }
        self.edges[edge] = state
    }
    
}

public func ==(lhs:DFAState, rhs:DFAState) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.edges == rhs.edges && lhs.isFinal == rhs.isFinal
}
