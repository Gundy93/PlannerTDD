//
//  DetailViewModel.swift
//  PlannerTDD
//
//  Created by Gundy on 2/13/24.
//

import Foundation

protocol DetailViewModel: AnyObject {
    
    var detailHandler: ((Bool) -> Void)? { get set }
    
    func setEditable(_ isEditable: Bool)
    func fetchDetailContents() -> (String, String, Date, String)
    func savePlan(title: String, deadline: Date, description: String)
    func deselectPlan()
}
