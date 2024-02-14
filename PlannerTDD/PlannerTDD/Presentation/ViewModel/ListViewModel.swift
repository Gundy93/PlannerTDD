//
//  ListViewModel.swift
//  PlannerTDD
//
//  Created by Gundy on 2/13/24.
//

import Foundation

protocol ListViewModel: AnyObject {
    
    var listHandler: (() -> Void)? { get set }
    
    func fetchContents(of state: State) -> [Content]
    func movePlan(ofID id: UUID, to state: State)
    func deletePlan(ofID id: UUID)
    func selectPlan(ofID id: UUID)
}
