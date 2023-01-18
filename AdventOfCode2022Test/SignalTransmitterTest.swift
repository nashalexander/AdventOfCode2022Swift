//
//  SignalTransmitterTest.swift
//  AdventOfCode2022Test
//
//  Created by Alex on 12/16/22.
//

import XCTest

class SignalTransmitterTest: XCTestCase {
    func testAllCharsAreUnique() throws {
        var input = "asdfghjk"
        var result = allCharsAreUnique(input)
        XCTAssertEqual(true, result)
        
        input = "asdfgauio"
        result = allCharsAreUnique(input)
        XCTAssertEqual(false, result)
    }
    
    func testFindStartOfPacket() throws {
        let input = "bvwbjplbgvbhsrlpgdmjqwftvncz"
        let headerLength = 4
        
        guard let index = findStartOfSequence(packet: input, headerLength: headerLength) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(5, index)
    }

}
