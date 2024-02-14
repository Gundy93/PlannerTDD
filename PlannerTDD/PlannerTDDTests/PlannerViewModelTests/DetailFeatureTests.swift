//
//  DetailFeatureTests.swift
//  PlannerTDDTests
//
//  Created by Gundy on 2/14/24.
//

import XCTest
@testable import PlannerTDD

final class DetailFeatureTests: XCTestCase {
    
    private var sut: DetailViewModel!

    override func setUpWithError() throws {
        sut = PlannerViewModel(planner: Planner(list: []))
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_detailHandler를할당했을때_setEditable을호출하면_detailHandler가실행된다() {
        // given
        var count = 0
        sut.detailHandler = { _ in
            count += 1
        }
        
        // when
        sut.setEditable(true)
        
        // then
        XCTAssertEqual(count, 1)
    }
    
    func test_detailHandler를할당했을때_setEditable에전달하는Bool값은_detailHandler에전달되는값과같다() {
        // given
        var result = false
        sut.detailHandler = { isEditable in
            result = isEditable
        }
        
        // when
        sut.setEditable(true)
        
        // then
        XCTAssertEqual(result, true)
    }
    
    func test_selectPlan을호출한다음_fetchDetailContents를호출하면_선택된Plan의값이반환된다() {
        // given
        let id = UUID()
        let title = "실행중인 계획"
        let deadline = Date(timeIntervalSinceNow: 86400)
        let description = "계획의 설명"
        let state = State.doing
        let plan = Plan(
            id: id,
            title: title,
            deadline: deadline,
            description: description,
            state: state
        )
        let viewModel = PlannerViewModel(planner: Planner(list: [plan]))
        
        viewModel.selectPlan(ofID: id)
        sut = viewModel
        
        // when
        let contents = sut.fetchDetailContents()
        
        // then
        XCTAssertEqual(contents.0, state.name)
        XCTAssertEqual(contents.1, title)
        XCTAssertEqual(contents.2, deadline)
        XCTAssertEqual(contents.3, description)
    }
    
    func test_선택된Plan이없을때_fetchDetailContents를호출하면_기본값이반환된다() {
        // given
        sut = PlannerViewModel(planner: Planner(list: []))
        
        // when
        let contents = sut.fetchDetailContents()
        
        // then
        XCTAssertEqual(contents.0, State.toDo.name)
        XCTAssertEqual(contents.1, String())
        XCTAssertEqual(contents.3, String())
    }
    
    func test_선택된Plan이있을때savePlan을호출하면_그요소의값이변한다() {
        // given
        let id = UUID()
        let title = "제목"
        let deadline = Date(timeIntervalSinceReferenceDate: 0)
        let description = "내용"
        let plan = Plan(
            id: id,
            title: title,
            deadline: deadline,
            description: description,
            state: .done
        )
        let viewModel = PlannerViewModel(planner: Planner(list: [plan]))
        
        viewModel.selectPlan(ofID: id)
        sut = viewModel
        
        // when
        sut.savePlan(title: "다른 제목", deadline: Date(), description: "다른 내용")
        viewModel.selectPlan(ofID: id)
        
        let contents = viewModel.fetchDetailContents()
        
        // then
        XCTAssertNotEqual(contents.1, title)
        XCTAssertNotEqual(contents.2, deadline)
        XCTAssertNotEqual(contents.3, description)
    }
    
    func test_선택된Plan이없을때_savePlan을호출하면_새로요소를저장한다() {
        // given
        let viewModel = PlannerViewModel(planner: Planner(list: []))
        
        sut = viewModel
        
        // when
        let toDos = viewModel.fetchContents(of: .toDo)
        
        sut.savePlan(title: "제목", deadline: Date(), description: "내용")
        
        // then
        XCTAssertNotEqual(viewModel.fetchContents(of: .toDo), toDos)
        XCTAssertGreaterThan(viewModel.fetchContents(of: .toDo).count, toDos.count)
    }
    
    func test_detailHandler를할당한다음_deselectPlan을호출하면_detailHandler가nil이된다() {
        // given
        sut.detailHandler = { _ in }
        
        // when
        sut.deselectPlan()
        
        // then
        XCTAssertNil(sut.detailHandler)
    }
}
