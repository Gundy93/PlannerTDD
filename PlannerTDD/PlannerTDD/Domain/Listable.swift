//
//  Listable.swift
//  PlannerTDD
//
//  Created by Gundy on 2/8/24.
//


protocol Listable {
    
    associatedtype Element: Identifiable
    
    var list: [Element] { get set }
    
    mutating func add(_ newElement: Element)
    mutating func edit(_ element: Element)
    mutating func delete(_ element: Element)
}

extension Listable {
    
    mutating func add(_ newElement: Element) {
        guard list.contains(where: { $0.id == newElement.id }) == false else { return }
        
        list.append(newElement)
    }
    
    mutating func edit(_ element: Element) {
        guard let index = list.firstIndex(where: { $0.id == element.id }) else { return }
        
        list[index] = element
    }
    
    mutating func delete(_ element: Element) {
        guard let index = list.firstIndex(where: { $0.id == element.id }) else { return }
        
        list.remove(at:index)
    }
}
