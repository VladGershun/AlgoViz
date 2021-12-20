//
//  TestAlgo.swift
//  AlgoViz
//
//  Created by Vlad Gershun on 12/19/21.
//

import SwiftUI

func gcd(_ a: Int,_ b: Int) -> Int {
    if b > a {
        return gcd(b, a)
    }
    sleep(2)
    let remainder = a % b
    if remainder == 0 { return b }
    return gcd(b, remainder)
}

func loopGCD(_ a: Int,_ b: Int) -> Int {
    var newA = a
    var newB = b
    if newB > newA {
        (newA, newB) = (newB, newA)
    }
    var remainder: Int
    repeat {
        remainder = newA % newB
        newA = newB
        newB = remainder
    } while remainder == 0
    return newB
}

struct GCDAlgorithm: Equatable {
    var smaller: Int
    var larger: Int
    var a: Int
    var b: Int
    var result: Int?
    
    init(_ a: Int, _ b: Int) {
        self.a = a
        self.b = b
        
        
        if b > a {
            larger = b
            smaller = a
        } else {
            larger = a
            smaller = b
        }
    }
    
    /// Runs one step of the algorithm and returns true when its complete. Upon completion `result` is non-nil.
    mutating func step() -> Bool {
        let remainder = larger % smaller
        
        if remainder != 0 {
            self.larger = smaller
            self.smaller = remainder
            return false
        } else {
            self.result = smaller
            return true
        }
    }
    
    static func isValid(a: Int, b: Int) -> Bool {
        if a <= 0 { return false }
        if b <= 0 { return false }
        return true
    }
}

func statefulGCD(_ a: Int,_ b: Int) -> Int {
    var state = GCDAlgorithm(a, b)
    while state.step() == false {
        // no-op
    }
    return state.result!
}

func asyncStatefulGCD(_ a: Int,_ b: Int) async -> Int {
    var state = GCDAlgorithm(a, b)
    while state.step() == false {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
    }
    return state.result!
}

//func asyncGCD(_ a: Int,_ b: Int) async -> Int {
//    if b > a {
//        return await asyncGCD(b, a)
//    }
//    try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
//    let remainder = a % b
//    if remainder == 0 { return b }
//    return await asyncGCD(b, remainder)
//}
