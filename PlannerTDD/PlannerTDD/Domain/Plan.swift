//
//  Plan.swift
//  PlannerTDD
//
//  Created by Gundy on 2/8/24.
//

import Foundation

struct Plan: Identifiable, Equatable {
    
    enum State {
        case toDo
        case doing
        case done
    }
    
    let id: UUID
    var title: String
    var deadline: Date
    var description: String
    var state: State
}
