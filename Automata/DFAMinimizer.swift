//
//  DFAMinimizer.swift
//  Automata
//
//  Created by Cooper Knaak on 10/7/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation
import CoronaConvenience

///Combines states into groups to minimize the number of states
///while recognizing the same language.
public struct DFAMinimizer {
    
    public init() {
        
    }
    
    ///Combines states of a DFA to generate an equivalent DFA
    ///with a minimal number of states.
    public func minimize(dfa:DFA) -> DFA {
        let alphabet = NFAConverter.alphabet(from: dfa.states)
        let finalGroup = Set(dfa.states.values.filter() { $0.isFinal })
        let nonFinalGroup = Set(dfa.states.values.filter() { !$0.isFinal })
        var groups = [finalGroup, nonFinalGroup]
        var remainingSets = [finalGroup]
        while remainingSets.count > 0 {
            let currentSet = remainingSets.removeLast()
            for char in alphabet {
                let toStates = self.states(states: dfa.states, with: char, to: currentSet)
                for currentGroup in groups {
                    let intersection = currentGroup.intersection(toStates)
                    let difference = currentGroup.subtracting(toStates)
                    guard intersection.count > 0 && difference.count > 0 else {
                        continue
                    }
                    if let index = groups.index(of: currentGroup) {
                        groups.remove(at: index)
                        groups.append(intersection)
                        groups.append(difference)
                    }
                    if let index = remainingSets.index(of: currentGroup) {
                        remainingSets.remove(at: index)
                        remainingSets.append(intersection)
                        remainingSets.append(difference)
                    } else {
                        if remainingSets.contains(toStates) {
                            if intersection.count <= difference.count {
                                remainingSets.append(intersection)
                            } else {
                                remainingSets.append(difference)
                            }
                        }
                    }
                }
            }
        }
        let states = self.merge(groups: groups, alphabet: alphabet, start: dfa.initialState?.identifier ?? "")
        return DFA(states: states)
    }
    
    ///Determines which states have an output state in a given group for a given input.
    ///- parameter states: All the states in the DFA.
    ///- parameter edge: The input that should generate the output state.
    ///- parameter group: A set of states.
    private func states(states:[String:DFAState], with edge:String, to group:Set<DFAState>) -> Set<DFAState> {
        return Set(states.values.filter() { (state:DFAState) -> Bool in
            guard let output = state.edges[edge] else {
                return false
            }
            return group.contains() { (outputState:DFAState) -> Bool in
                return outputState.identifier == output
            }
        })
    }
    
    ///Merges a sets of DFA states (considered to be in the same group)
    ///into single DFA states.
    ///- parameter groups: An array of sets of DFAStates (considered to be in the same "group",
    ///meaning for every input, each element in the group has an output in the same (but
    ///not necessarily the current) "group". Each set is expected to be disjoint.
    ///- parameter alphabet: A set of strings of valid inputs. It is assumed each string only
    ///has 1 character.
    ///- returns: An array of DFAStates, where each state represents the aggregation of a
    ///set of states.
    private func merge(groups:[Set<DFAState>], alphabet:Set<String>, start:String) -> [DFAState] {
        var states = groups.map() { (states:Set<DFAState>) -> (DFAState, [String:String], Bool) in
            let identifier = self.combineIdentifiers(for: states)
            let isFinal = states.reduce(false) { $0 || $1.isFinal }
            let edgesTo = [String:String](uniqueKeysWithValues: alphabet.map() { self.mergeEdges(from: states, for: $0, groups: groups) })
            let isStart = states.contains() { $0.identifier == start }
            return (DFAState(identifier: identifier, isFinal: isFinal), edgesTo, isStart)
        }
        for i in 0..<states.count {
            for (edge, toEdge) in states[i].1 {
                let toStateIndex = states.index() { $0.0.identifier == toEdge }!
                try! states[i].0.add(edge: edge, to: states[toStateIndex].0.identifier)
            }
        }
        //One of the states is guaranteed to be the start state.
        let startIndex = states.index() { $0.2 }!
        states.swapAt(0, startIndex)
        return states.map() { $0.0 }
    }
    
    ///Combines the output states for a given input for all states in a set into a single identifier.
    ///- parameter states: An array of disjoint sets of states.
    ///- parameter edge: An input to transition the given states to.
    private func mergeEdges(from states:Set<DFAState>, for edge:String, groups:[Set<DFAState>]) -> (String, String) {
        for output in states.flatMap({ $0.edges[edge] }) {
            for group in groups {
                if group.contains(where: { $0.identifier == output }) {
                    return (edge, self.combineIdentifiers(for: group))
                }
            }
        }
        let edges = Set<String>(array: states.flatMap() { $0.edges[edge] })
        let sortedEdges = edges.sorted() { $0 < $1 }
        return (edge, sortedEdges.joined(separator: ","))
    }
    
    ///Combines the identifiers of a set of DFAStates into a single
    ///identifier representing the aggregate state.
    ///- parameter states: A set of DFAStates.
    ///- returns: A String representing the combined identifiers of the passed in states.
    private func combineIdentifiers(for states:Set<DFAState>) -> String {
        return states.map() { $0.identifier } .sorted() { $0 < $1 } .joined(separator: ",")
    }

}
