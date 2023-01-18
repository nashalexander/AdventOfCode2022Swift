//
//  CampCleaniing.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/6/22.
//

import Foundation

struct Cleaner
{
    var campLow : Int
    var campHigh : Int
    
    init(low : Int, high : Int)
    {
        campLow = low
        campHigh = high
    }
    
    func contains(_ other : Cleaner) -> Bool
    {
        if(campLow <= other.campLow && other.campHigh <= campHigh)
        {
            return true
        }
        
        return false
    }
    
    func overlaps(_ other : Cleaner) -> Bool
    {
        if(campLow <= other.campHigh && other.campLow <= campHigh)
        {
            return true
        }
        
        return false
    }
}

class CleanerDatabase
{
    var cleaners : [(Cleaner, Cleaner)] = []
    
    func numFullyContain() -> Int
    {
        var count = 0
        for cleanerPair in cleaners
        {
            if(cleanerPair.0.contains(cleanerPair.1)
               || cleanerPair.1.contains(cleanerPair.0))
            {
                count += 1
            }
        }
        return count
    }
    
    func numOverlap() -> Int
    {
        var count = 0
        for cleanerPair in cleaners
        {
            if(cleanerPair.0.overlaps(cleanerPair.1))
            {
                count += 1
            }
        }
        return count
    }
}

func getCampCleanerDatabase(_ filename : String) -> CleanerDatabase?
{
    guard let file = freopen(filename, "r", stdin) else {
        print("Cannot open file")
        return nil
    }
    defer {
        fclose(file)
    }
    
    let database = CleanerDatabase()
    
    while let line : String = readLine()
    {
        let cleanersStrArray = line.components(separatedBy: ",")
        
        assert(cleanersStrArray.count == 2)
        
        var cleanerPair : [Cleaner] = []
        for cleanerStr in cleanersStrArray{
            let boundCharArray = cleanerStr.components(separatedBy: "-")
            assert(boundCharArray.count == 2)
            
            guard let low = Int(boundCharArray[0]) else {
                print("Bad lower bound: \(boundCharArray[0])")
                return nil
            }
            guard let high = Int(boundCharArray[1]) else {
                print("Bad upper bound: \(boundCharArray[1])")
                return nil
            }
            
            cleanerPair.append(Cleaner(low: low, high: high))
        }
        database.cleaners.append((cleanerPair[0], cleanerPair[1]))
    }
    
    return database
}

func campCleanerOverlapCalculator(_ files : [String])
{
    for file in files {
        guard let database = getCampCleanerDatabase(file) else {
            print("bad database in file: \(file)")
            continue
        }
        
        let numContain = database.numFullyContain()
        
        let numOverlap = database.numOverlap()
        
        print("The number of pairs that have one pair that full contains another from file: \(file) is num: \(numContain)")
        print("The number of pairs that have some overlap is num: \(numOverlap)")
    }
}
