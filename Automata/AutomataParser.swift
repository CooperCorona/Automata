//
//  AutomataParser.swift
//  Automata
//
//  Created by Cooper Knaak on 10/9/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation
import CoronaConvenience

///Represents errors that can occur during parsing.
enum AutomataParserError: Error {
    ///Represents the error in which a line is malformatted.
    ///The associated value is the line number (0-indexed).
    case Malformatted(String, Int)
}

///Parses an automata grammar into an Automata instance.
public struct AutomataParser {
    
    ///Represents metadata about a state.
    public enum Annotation:String {
        ///Represents a "final" state (one that should cause the
        ///automata to accept the string).
        case final = "Final"
        
        ///Determines if this annotation is present in an array of annotations.
        ///- parameter annotations: An array of annotations.
        ///- returns: True if the array contains this annotation, false otherwise.
        public func matches(_ annotations:[String]) -> Bool {
            return annotations.contains(self.rawValue)
        }
        
    }
    
    ///Represents the result of parsing indivudal transition=output pairs.
    private struct EdgeResult {
        ///The input of the transition.
        var edge:String
        ///The output of the transition.
        var state:String
    }
    
    ///Represents the result of parsing individual transition=output pairs
    /// of a PDA.
    private struct PDAEdgeResult {
        ///The input of the transition.
        var edge:String
        ///The string to push onto the stack (can be epsilon).
        var push:String
        ///The string to pop from the stack (can be epsilon).
        var pop:String
    }
    
    ///Represents the result of parsing individual states.
    private struct LineResult {
        ///The identifier of this state.
        var state:String
        ///The annotations assoicated with this state.
        var annotations:[String]
        ///The transitions associated with this state.
        var edges:[EdgeResult]
        
        ///Determines if this state possesses a certain annotation.
        ///- parameter annotation: An Annotation.
        ///- returns: True if this state possesses the given annotation, false otherwise.
        func matches(_ annotation:Annotation) -> Bool {
            return annotation.matches(self.annotations)
        }
    }
    
    public init() {
        
    }
    
    ///Parses an array of lines into an array of LineResults.
    ///- parameter lines: An array of lines, each line representing a state.
    ///- returns: An array of LineResults corresponding to the passed in lines.
    private func parse(lines:[String]) throws -> [LineResult] {
        return try lines.enumerated().map() { (i:Int, line:String) -> LineResult in
            return try self.parse(line: line, number: i)
        }
    }
    
    ///Parses an array of lines (each line reprenting a state) into a DFA instance.
    ///- parameter lines: An array of lines with each line representing an individual state.
    ///The first element in the array is considered the start state.
    ///- returns: A DFA instance corresponding to the given lines.
    public func parseDFA(lines:[String]) throws -> DFA {
        let results = try self.parse(lines: lines)
        var states = results.map() { DFAState(identifier: $0.state, isFinal: $0.matches(.final)) }
        for (i, result) in results.enumerated() {
            for edge in result.edges {
                try states[i].add(edge: edge.edge, to: edge.state)
            }
        }
        return DFA(states: states)
    }
    
    ///Parses an array of lines (each line representing a state) into a NFA instance.
    ///- parameter lines: An array of lines with each line representing an individual state.
    ///The first element in the array is considered the start state.
    ///- returns: An NFA instance corresponding to the given lines.
    public func parseNFA(lines:[String]) throws -> NFA {
        let results = try self.parse(lines: lines)
        var states = results.map() { NFAState(identifier: $0.state, isFinal: $0.matches(.final)) }
        for (i, result) in results.enumerated() {
            for edge in result.edges {
                states[i].add(edge: edge.edge, to: edge.state)
            }
        }
        return NFA(states: states)
    }
    
    ///Parsers an array of lines (each line representing a state) into a PDA instance.
    ///- parameter lines: An array of lines with each line representing an individual state.
    ///The first element in the array is considered the start state.
    ///- returns: A PDA instance coresponding to the given lines.
    public func parsePDA(lines:[String]) throws -> PDA {
        let results = try self.parse(lines: lines)
        var states = results.map() { PDAState(identifier: $0.state, isFinal: $0.matches(.final)) }
        for (i, result) in results.enumerated() {
            for edge in result.edges {
                let edgeResult = try self.parse(pdaEdge: edge.edge, number: i)
                states[i].add(edge: edgeResult.edge, pop: edgeResult.pop, push: edgeResult.push, to: edge.state)
            }
        }
        return PDA(states: states)
    }
    
    ///Parses a line into a LineResult instance.
    ///- parameter line: The line to parse.
    ///- parameter number: The line number (assumed to be 0-indexed).
    ///- returns: A LineResult instance corresponding to the given line.
    private func parse(line:String, number:Int) throws -> LineResult {
        guard let result = line.match("^(.+?)\\s*(\\(.+?\\))?:\\s*(.*?)$") else {
            throw AutomataParserError.Malformatted(line, number)
        }
        let identifier = result[0]
        let annotations:[String]
        let edges:[EdgeResult]
        //If the annotation capture group is matched, then there
        //are 3 groups.
        switch result.groups.count {
        case 3:
            annotations = result[1].substring(from: 1).substring(to: result[1].characterCount - 2).components(separatedBy: " ")
            edges = self.parse(edges: result[2])
        case 2:
            annotations = []
            edges = self.parse(edges: result[1])
        default:
            annotations = []
            edges = []
        }
        return LineResult(state: identifier, annotations: annotations, edges: edges)
    }
    
    ///Parses a string containing input=output pairs into an array of EdgeResults.
    ///- parameter edges: A string containing input=output pairs.
    ///- returns:
    private func parse(edges:String) -> [EdgeResult] {
        guard edges != "" else {
            return []
        }
        return edges.components(separatedBy: " ").map() {
            let comps = $0.components(separatedBy: "=")
            return EdgeResult(edge: comps[0], state: comps[1])
        }
    }
    
    private func parse(pdaEdge:String, number:Int) throws -> PDAEdgeResult {
        guard let result = pdaEdge.match("^(.+?),(.+?)->(.+?)$") else {
            throw AutomataParserError.Malformatted(pdaEdge, number)
        }
        let edge = result.groups[0]
        let pop = result.groups[1]
        let push = result.groups[2]
        return PDAEdgeResult(edge: edge, push: push, pop: pop)
    }
    
}
