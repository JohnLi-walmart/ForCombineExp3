//
//  ViewController.swift
//  ForCombineExp3
//
//  Created by Zhaoyang Li on 5/10/21.
//

import XCTest
import Combine

class CombineTests: XCTestCase {
    
    func testPublishSubjectPumping() {
        measure {
            var sum = 0
            let subject = PassthroughSubject<Int, Never>()

            let subscription = subject
                .sink(receiveValue: { x in
                    sum += x
                })

            for _ in 0 ..< iterations * 100 {
                subject.send(1)
            }
            
            subscription.cancel()
            
            XCTAssertEqual(sum, iterations * 100)
        }
    }

    func testPublishSubjectCreating() {
        measure {
            var sum = 0

            for _ in 0 ..< iterations * 10 {
                let subject = PassthroughSubject<Int, Never>()

                let subscription = subject
                    .sink(receiveValue: { x in
                        sum += x
                    })

                for _ in 0 ..< 1 {
                    subject.send(1)
                }

                subscription.cancel()
            }

            XCTAssertEqual(sum, iterations * 10)
        }
    }

    func testMapFilterPumping() {
        measure {
            var sum = 0
            
            let subscription = AnyPublisher<Int, Never>.create { subscriber in
                    for _ in 0 ..< iterations * 10 {
                        _ = subscriber.receive(1)
                    }
                }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .map { $0 }.filter { _ in true }
                .sink(receiveValue: { x in
                    sum += x
                })

            subscription.cancel()

            XCTAssertEqual(sum, iterations * 10)
        }
    }


    func testFlatMapsPumping() {
        measure {
            var sum = 0
            let subscription = AnyPublisher<Int, Never>.create { subscriber in
                    for _ in 0 ..< iterations * 10 {
                        _ = subscriber.receive(1)
                    }
                }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .flatMap { x in Just(x) }
                .sink(receiveValue: { x in
                    sum += x
                })

            subscription.cancel()

            XCTAssertEqual(sum, iterations * 10)
        }
    }

