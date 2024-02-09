//
//  PlannerTests.swift
//  PlannerTDDTests
//
//  Created by Gundy on 2/8/24.
//

import XCTest
@testable import PlannerTDD

final class PlannerTests: XCTestCase {
    
    private var sut: Planner!

    override func setUpWithError() throws {
        sut = Planner(list: [])
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_Plan인스턴스를_Planner인스턴스의add에전달하면_list의last가된다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        
        // when
        sut.add(plan)
        
        // then
        XCTAssertEqual(sut.list.last, plan)
    }
    
    func test_Plan인스턴스를_빈배열로초기화된Planner인스턴스의add에전달하면_list는그Plan인스턴스만가진배열이된다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        
        // when
        sut = Planner(list: [])
        sut.add(plan)
        
        // then
        XCTAssertEqual(sut.list, [plan])
    }
    
    func test_list가빈배열이아닌경우_이미가진요소를add에전달하면_list의카운트는늘어나지않는다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        sut = Planner(list: [plan])
        let count = sut.list.count
        
        // when
        sut.add(plan)
        
        // then
        XCTAssertEqual(sut.list.count, count)
    }
    
    func test_list가빈배열이아닌경우_수정된인스턴스를Planner인스턴스의edit에전달하면_list에는수정전인스턴스가남지않는다() {
        // given
        let originPlan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        sut = Planner(list: [originPlan])
        
        // when
        var editedPlan = originPlan
        editedPlan.title = "수정됨"
        sut.edit(editedPlan)
        
        // then
        XCTAssertFalse(sut.list.contains(originPlan))
    }
    
    func test_list가빈배열이아닌경우_list에없는요소를edit에전달하면_list는변하지않는다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        let list = [plan]
        sut = Planner(list: list)
        
        // when
        let newPlan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        sut.edit(newPlan)
        
        // then
        XCTAssertEqual(sut.list, list)
    }
    
    func test_list의count가1일때_해당요소를Planner인스턴스의delete에전달하면_list는빈배열이된다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        sut = Planner(list: [plan])
        
        // when
        sut.delete(plan)
        
        // then
        XCTAssertTrue(sut.list.isEmpty)
    }
    
    func test_list가빈배열이아닌경우_list에없는요소를delete에전달하면_list는변하지않는다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        let list = [plan]
        sut = Planner(list: list)
        
        // when
        let newPlan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        sut.delete(newPlan)
        
        // then
        XCTAssertEqual(sut.list, list)
    }
}
