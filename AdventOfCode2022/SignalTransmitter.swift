//
//  SignalTransmitter.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/16/22.
//

import Foundation

func allCharsAreUnique(_ str : String) -> Bool
{
    var strSet : Set<Character> = []
    for char in str
    {
        if(strSet.contains(char))
        {
            return false
        }
        strSet.insert(char)
    }
    return true
}

func findStartOfSequence(packet : String, headerLength : Int) -> Int?
{
    var header : String = ""
    var index = 0
    for char in packet
    {
        header.append(char)
        index += 1
        
        assert(header.count <= headerLength)
        if(header.count == headerLength)
        {
            if(allCharsAreUnique(header))
            {
                return index
            }
            else
            {
                header.remove(at: header.startIndex)
                assert(header.count == headerLength - 1)
            }
        }
    }
    return nil
}

func signalTransmitter(_ strArray : [String]) throws
{
    for str in strArray
    {
        guard let validMarkerEnd = findStartOfSequence(packet: str, headerLength : 14) else {
            print("Packet contains no valid header")
            throw NSError()
        }
        
        print("Valid marker found after character \(validMarkerEnd)")
    }
}
