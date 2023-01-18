//
//  CampCleaningTest.swift
//  AdventOfCode2022Test
//
//  Created by Alex on 12/6/22.
//

import XCTest

class CampCleaningTest: XCTestCase {
    
    func testCleaner() throws{
        let cleaner = Cleaner(low: 2, high: 5)
        
        var does = cleaner.contains(Cleaner(low: 2, high: 3))
        XCTAssert(does)
        
        does = cleaner.overlaps(Cleaner(low: 2, high: 7))
        XCTAssert(does)
        
        does = cleaner.overlaps(Cleaner(low: 3, high: 4))
        XCTAssert(does)
    }
    
    func testCleanerDatabaseContains() throws{
        let database = CleanerDatabase()
        
        database.cleaners.append((Cleaner(low:1,high:4), Cleaner(low:2,high:3)))
        database.cleaners.append((Cleaner(low:1,high:4), Cleaner(low:3,high:7)))
        database.cleaners.append((Cleaner(low:3,high:4), Cleaner(low:2,high:5)))
        
        let numContain = database.numFullyContain()
        
        XCTAssert(numContain == 2)
    }
    
    func testCleanerDatabaseOverlaps() throws{
        let database = CleanerDatabase()
        
        database.cleaners.append((Cleaner(low:1,high:4), Cleaner(low:2,high:3)))
        database.cleaners.append((Cleaner(low:1,high:4), Cleaner(low:3,high:7)))
        database.cleaners.append((Cleaner(low:3,high:4), Cleaner(low:2,high:5)))
        
        let numOverlap = database.numOverlap()
        
        XCTAssertEqual(3, numOverlap)
    }

}
