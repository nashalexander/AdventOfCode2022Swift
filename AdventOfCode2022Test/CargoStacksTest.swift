//
//  CargoStacksTest.swift
//  AdventOfCode2022Test
//
//  Created by Alex on 12/6/22.
//

import XCTest

class CargoStacksTest: XCTestCase {
    
    func testCargoEnvironment() throws {
        let inputStr : [String] =
        [
            "    [D]      ",
            "[N] [C]  ",
            "[Z] [M] [P]    ",
            " 1   2   3  ",
            "",
            "move 1 from 2 to 1",
            "move 3 from 1 to 3",
            "move 2 from 2 to 1",
            "move 1 from 1 to 2"
        ]
        
        guard var env = createEnvironment(inputStr) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(env.cargoStacks.stacks.count, 3)
        XCTAssertEqual(env.instructions.count, 4)
        XCTAssertEqual(env.cargoStacks.getTopCrates(), "NDP")
        
        try! env.doInstructions()
        
        XCTAssertEqual(env.cargoStacks.getTopCrates(), "MCD")
    }

}
