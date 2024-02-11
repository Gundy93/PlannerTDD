//
//  State.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

enum State: Int, CaseIterable {
    case toDo
    case doing
    case done
    
    var name: String {
        switch self {
        case .toDo:
            return "TODO"
        case .doing:
            return "DOING"
        case .done:
            return "DONE"
        }
    }
}
