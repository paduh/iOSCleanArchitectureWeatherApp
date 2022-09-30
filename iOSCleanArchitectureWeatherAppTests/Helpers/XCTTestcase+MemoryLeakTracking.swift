//
//  XCTTestcase+MemoryLeakTracking.swift
//  iOSCleanArchitectureMoviesApp
//
//  Created by Perfect Aduh on 27/09/2022.
//

import Foundation

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, potential momery leak", file: file, line: line)
        }
    }
}
