//
//  AdventOfCode2022Test.swift
//  AdventOfCode2022Test
//
//  Created by Alex on 12/3/22.
//
@testable import AdventOfCode2022
import XCTest

class AdventOfCode2022Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let rucksack = RuckSack("fghityui")
        
        XCTAssert(rucksack.getComparment(true) == "fghi")
        XCTAssert(rucksack.getComparment(false) == "tyui")
        
        if let dupe = rucksack.getDupe() {
            XCTAssert(dupe == "i")
        }
        else{
            XCTFail()
        }
        
        XCTAssert(getItemPriority("a") == 1)
        XCTAssert(getItemPriority("z") == 26)
        XCTAssert(getItemPriority("A") == 27)
        XCTAssert(getItemPriority("Z") == 52)
        
        var troop = RuckSackTroop()
        troop.allRucksacks.append(RuckSack("vJrwpWtwJgWrhcsFMMfFFhFp"))
        troop.allRucksacks.append(RuckSack("jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"))
        troop.allRucksacks.append(RuckSack("PmmdzqPrVvPwwTWBwg"))
        
        XCTAssert(troop.getCommonItem() == "r")
        
        var troops : [RuckSackTroop] = []
        
        troops.append(troop)
        
        troop = RuckSackTroop()
        troop.allRucksacks.append(RuckSack("wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn"))
        troop.allRucksacks.append(RuckSack("ttgJtRGJQctTZtZT"))
        troop.allRucksacks.append(RuckSack("CrZsJsPPZsGzwwsLwLmpwMDw"))
        
        XCTAssert(troop.getCommonItem() == "Z")
        
        troops.append(troop)
        
    }
    
    func testStr() throws {
        let str = "h k l"
        
        let charArray = str.components(separatedBy: " ")
        XCTAssertEqual(charArray.count, 3)
        XCTAssertEqual("h", charArray[0])
        XCTAssertEqual("k", charArray[1])
        XCTAssertEqual("l", charArray[2])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
