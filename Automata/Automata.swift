//
//  Automata.swift
//  Automata
//
//  Created by Cooper Knaak on 10/6/17.
//  Copyright © 2017 CooperCorona. All rights reserved.
//

import Foundation

public protocol Automata {
    
    func accepts(string:String) throws -> Bool
    
}
