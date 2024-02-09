//
//  PlannerViewModel.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

final class PlannerViewModel {
    
    private var planner: Planner {
        didSet { plannerDidUpdate() }
    }
    
    init(planner: Planner) {
        self.planner = planner
    }
    
    private func plannerDidUpdate() {}
}
