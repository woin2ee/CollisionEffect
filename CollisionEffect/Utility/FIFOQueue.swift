//
//  FIFOQueue.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/16/24.
//

import SpriteKit

public struct FIFOQueue {
    
    class Node {
        let content: SKShapeNode
        var next: Node?
        var previous: Node?
        
        init(content: SKShapeNode) {
            self.content = content
            self.next = nil
            self.previous = nil
        }
    }
    
    private var first: Node?
    
    private var last: Node?
    
    public let maxCapacity: Int
    
    public var count: Int
    
    private let lock: NSRecursiveLock = NSRecursiveLock()
    
    public init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
        self.count = 0
    }
    
    public mutating func enqueue(_ element: SKShapeNode) -> SKShapeNode? {
        lock.lock(); defer { lock.unlock() }
        
        let node = Node(content: element)
        first?.previous = node
        node.next = first
        first = node
        
        if last == nil {
            last = node
        }
        
        count += 1
        
        if count > maxCapacity {
            return dequeue()
        }
        
        return nil
    }
    
    public mutating func dequeue() -> SKShapeNode? {
        lock.lock(); defer { lock.unlock() }
        
        guard let last else {
            return nil
        }
        
        count -= 1
        
        let content = last.content
        
        if let previous = last.previous {
            previous.next = nil
            self.last = previous
        } else {
            self.first = nil
            self.last = nil
        }
        
        return content
    }
}
