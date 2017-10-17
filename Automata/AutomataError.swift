//
//  AutomataError.swift
//  Automata
//
//  Created by Cooper Knaak on 10/6/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

public enum AutomataError: Error {
    ///Represents an error in which an edge is added
    ///to a DFA which already has an edge associated
    ///with that input.
    case DuplicateInput(String, String)
    ///Represents an error in which an input string to
    ///a finite automata contains a character outside
    ///the automata's alphabet.
    case CharacterNotInAlphabet(String)
}
