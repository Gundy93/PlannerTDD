//
//  ListFeatureTests.swift
//  PlannerTDDTests
//
//  Created by Gundy on 2/9/24.
//

import XCTest
@testable import PlannerTDD

final class ListFeatureTests: XCTestCase {
    
    private var sut: PlannerViewModel!

    override func setUpWithError() throws {
        sut = PlannerViewModel(planner: Planner(list: []))
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_planner의list가비었을때_fetchContents를호출하면_빈배열을반환한다() {
        // given
        sut = PlannerViewModel(planner: Planner(list: []))
        
        // when
        let toDos = sut.fetchContents(of: .toDo)
        let doings = sut.fetchContents(of: .doing)
        let dones = sut.fetchContents(of: .done)
        
        // then
        XCTAssertTrue(toDos.isEmpty)
        XCTAssertTrue(doings.isEmpty)
        XCTAssertTrue(dones.isEmpty)
    }
    
    func test_planner에state가toDo인요소가없을때_fetchContents를toDo로호출하면_빈배열을반환한다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .doing
        )
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        
        // when
        let toDos = sut.fetchContents(of: .toDo)
        
        // then
        XCTAssertTrue(toDos.isEmpty)
    }
    
    func test_planner에state가toDo인요소가있을때_fetchContents를toDo로호출하면_반환값은빈배열이아니다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        
        // when
        let toDos = sut.fetchContents(of: .toDo)
        
        // then
        XCTAssertFalse(toDos.isEmpty)
    }
    
    func test_planner에요소가있을때_movePlan을호출하면_fetchContents가반환하는배열의길이가달라진다() {
        // given
        let id = UUID()
        let plan = Plan(
            id: id,
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        
        // when
        let toDoCount = sut.fetchContents(of: .toDo).count
        let doingCount = sut.fetchContents(of: .doing).count
        sut.movePlan(ofID: id, to: .doing)
        
        // then
        XCTAssertNotEqual(toDoCount, sut.fetchContents(of: .toDo).count)
        XCTAssertNotEqual(doingCount, sut.fetchContents(of: .doing).count)
    }
    
    func test_planner에요소가있을때_deletePlan에해당요소의id를전달하면_fetchContents가반환하는배열의길이가달라진다() {
        // given
        let id = UUID()
        let plan = Plan(
            id: id,
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        
        // when
        let toDoCount = sut.fetchContents(of: .toDo).count
        sut.deletePlan(ofID: id)
        
        // then
        XCTAssertNotEqual(toDoCount, sut.fetchContents(of: .toDo).count)
    }
    
    func test_planner에요소가있을때_deletePlan에없는id를전달하면_fetchContents가반환하는배열의길이가달라지지않는다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        
        // when
        let toDoCount = sut.fetchContents(of: .toDo).count
        sut.deletePlan(ofID: UUID())
        
        // then
        XCTAssertEqual(toDoCount, sut.fetchContents(of: .toDo).count)
    }
    
    func test_listHandler에전달된클로저는_movePlan으로인해planner가변경되면_호출된다() {
        // given
        let id = UUID()
        let plan = Plan(
            id: id,
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        var number = 0
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        sut.listHandler = {
            number += 1
        }
        
        // when
        sut.movePlan(ofID: id, to: .doing)
        
        // then
        XCTAssertEqual(number, 1)
    }
    
    func test_listHandler에전달된클로저는_deletePlan으로인해planner가변경되면_호출된다() {
        // given
        let id = UUID()
        let plan = Plan(
            id: id,
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        var number = 0
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        sut.listHandler = {
            number += 1
        }
        
        // when
        sut.deletePlan(ofID: id)
        
        // then
        XCTAssertEqual(number, 1)
    }
    
    func test_listHandler에전달된클로저는_deletePlan에없는id가전달되면_호출되지않는다() {
        // given
        let plan = Plan(
            id: UUID(),
            title: String(),
            deadline: Date(),
            description: String(),
            state: .toDo
        )
        var number = 0
        sut = PlannerViewModel(planner: Planner(list: [plan]))
        sut.listHandler = {
            number += 1
        }
        
        // when
        sut.deletePlan(ofID: UUID())
        
        // then
        XCTAssertNotEqual(number, 1)
    }
}
