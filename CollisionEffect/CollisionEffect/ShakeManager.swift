//
//  ShakeManager.swift
//  CollisionEffect
//
//  Created by Jaewon Yun on 7/24/24.
//

import CoreMotion
import Foundation

final class ShakeManager {
    
    /// 낮을 수록 쉽게 흔들기에 반응합니다.
    enum DetectingThreshold: Double {
        case low = 1.3
        case medium = 3.0
        case high = 5.4
    }
    
    private let motionManager: CMMotionManager
    
    let operationQueue: OperationQueue
    
    /// 흔들림 감지 주기
    ///
    /// 이 주기 마다 알림을 보냄. 이 간격이 지날때 마다 가장 강했던 흔들림을 채택합니다.
    let detectionInterval: TimeInterval
    
    let detectingThreshold: DetectingThreshold
    
    init() {
        let motionManager = CMMotionManager()
        self.motionManager = motionManager
        
        let queue = OperationQueue()
        queue.name = "TestQueue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        self.operationQueue = queue
        
        self.detectionInterval = 0.2
        self.detectingThreshold = .low
    }
    
    func startDetecting(withHandler handler: @escaping ((_ x: Double, _ y: Double, _ z: Double) -> Void)) {
        var isWaiting = false
        let handlerExecutingQueue = DispatchQueue(label: "handler-executing-queue", qos: .userInteractive)
        var maxAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
        
        var startDirectionalSign: (x: Sign, y: Sign, z: Sign) = (.zero, .zero, .zero)
        
        motionManager.startDeviceMotionUpdates(to: operationQueue) { motion, error in
            if let error {
                debugPrint(error)
                return
            }
            
            guard let motion else {
                debugPrint("No data.")
                return
            }
            
            if isWaiting, motion.userAcceleration.r > maxAcceleration.r {
                maxAcceleration = motion.userAcceleration
            }
            
            if motion.userAcceleration.r > self.detectingThreshold.rawValue, !isWaiting {
                debugPrint("Shaking detected!")
                
                isWaiting = true
                maxAcceleration = motion.userAcceleration
                startDirectionalSign = (
                    Sign(motion.userAcceleration.x),
                    Sign(motion.userAcceleration.y),
                    Sign(motion.userAcceleration.z)
                )
                
                debugPrint("Sign of shaking direction: \(startDirectionalSign)")

                handlerExecutingQueue.asyncAfter(deadline: .now() + self.detectionInterval) {
                    let x: Double = switch startDirectionalSign.x {
                    case .positive: abs(maxAcceleration.x)
                    case .negative: -(abs(maxAcceleration.x))
                    case .zero: 0
                    }
                    let y: Double = switch startDirectionalSign.y {
                    case .positive: abs(maxAcceleration.y)
                    case .negative: -(abs(maxAcceleration.y))
                    case .zero: 0
                    }
                    let z: Double = switch startDirectionalSign.z {
                    case .positive: abs(maxAcceleration.z)
                    case .negative: -(abs(maxAcceleration.z))
                    case .zero: 0
                    }
                    
                    handler(x, y, z)
                    isWaiting = false
                    debugPrint(maxAcceleration.r)
                    debugPrint("Shaking prepared!")
                }
            }
        }
    }
    
    func stopDetecting() {
        motionManager.stopDeviceMotionUpdates()
    }
}

extension DispatchTimeInterval: Comparable {
    
    private var totalNanoseconds: Int64 {
        switch self {
        case .nanoseconds(let ns): return Int64(ns)
        case .microseconds(let us): return Int64(us) * 1_000
        case .milliseconds(let ms): return Int64(ms) * 1_000_000
        case .seconds(let s): return Int64(s) * 1_000_000_000
        case .never: fatalError("Couldn't compare, there is no interval.")
        @unknown default:
            fatalError("It's an unknown case.")
        }
    }
    
    public static func <(lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
        if lhs == .never { return false }
        if rhs == .never { return true }
        return lhs.totalNanoseconds < rhs.totalNanoseconds
    }
}

extension CMAcceleration {
    var r: Double {
        sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }
}

enum Sign {
    case positive
    case negative
    case zero
    
    init(_ num: (some SignedNumeric & Comparable)) {
        if num == 0 {
            self = .zero
        } else if num > 0 {
            self = .positive
        } else {
            self = .negative
        }
    }
}

extension SignedNumeric where Self: Comparable {
    
    var sign: Sign {
        return if self == 0 {
            .zero
        } else if self > 0 {
            .positive
        } else {
            .negative
        }
    }
}
