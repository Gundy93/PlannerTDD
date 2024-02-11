//
//  PlannerViewModel.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import Foundation

final class PlannerViewModel {
    
    private var planner: Planner {
        didSet { plannerDidUpdate() }
    }
    
    init(planner: Planner) {
        self.planner = planner
    }
    
    private func plannerDidUpdate() {
        listHandler?()
    }
    
    // MARK: - ListFeature
    
    struct Content: Hashable {
        
        let title: String
        let description: String
        let deadline: String
        let isOverdue: Bool
        let id: UUID
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter =  DateFormatter()
        
        formatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        formatter.dateStyle = .long
        
        return formatter
    }()
    var listHandler: (() -> Void)?
    
    func fetchContents(of state: State) -> [Content] {
        planner.list.compactMap { plan in
            guard plan.state == state else { return nil }
            
            return format(plan: plan)
        }
    }
    
    private func format(plan: Plan) -> Content {
        Content(
            title: plan.title,
            description: plan.description,
            deadline: dateFormatter.string(from: plan.deadline),
            isOverdue: Date(timeInterval: 86399, since: plan.deadline) < Date.now,
            id: plan.id
        )
    }
    
    func movePlan(ofID id: UUID, to state: State) {
        guard var plan = planner.list.first(where: { $0.id == id }) else { return }
        
        plan.state = state
        edit(plan: plan)
    }
    
    private func edit(plan: Plan) {
        planner.edit(plan)
    }
    
    func deletePlan(ofID id: UUID) {
        guard let plan = planner.list.first(where: { $0.id == id }) else { return }
        
        planner.delete(plan)
    }
}
