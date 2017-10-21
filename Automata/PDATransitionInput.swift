//
//  PDATransitionInput.swift
//  Automata
//
//  Created by Cooper Knaak on 10/17/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Represents the necessary input to the transition function
///to change states in a PDA.
public struct PDATransitionInput: Hashable {
    
    ///The output of the string necessary to follow this transition.
    public let output:String
    ///The element that must be on top of the stack to follow this transition.
    public let pop:String
    ///The element that is pushed on to the stack when following this transition.
    public let push:String
    
    public var hashValue: Int {
        return (self.output.hashValue * 31) ^ (self.pop.hashValue * 13) ^ (self.push.hashValue)
    }
    
    ///Initializes a PDATransitionInput instance with the given parameters.
    ///- parameter output: The output state.
    ///- parameter pop: The element to pop from the stack. Can be epsilon.
    ///- parameter push: The element to push on to the stack. Can be epsilon.
    public init(output:String, pop:String, push:String) {
        self.output = output
        self.pop = pop
        self.push = push
    }
    
}

public func ==(lhs:PDATransitionInput, rhs:PDATransitionInput) -> Bool {
    return lhs.output == rhs.output && lhs.pop == rhs.pop && lhs.push == rhs.push
}
