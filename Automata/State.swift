//
//  State.swift
//  Automata
//
//  Created by Cooper Knaak on 10/9/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

///Defines a common interface for dealing with
///finite automata states.
public protocol State {
    
    ///The input transitions for this state.
    var transitions:[String] { get }
    
}
