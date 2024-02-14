//
//  Content.swift
//  PlannerTDD
//
//  Created by Gundy on 2/13/24.
//

import Foundation

struct Content: Hashable {
    
    let title: String
    let description: String
    let deadline: String
    let isOverdue: Bool
    let id: UUID
}
