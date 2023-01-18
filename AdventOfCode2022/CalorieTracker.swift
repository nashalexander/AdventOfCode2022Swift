//
//  CalorieTracker.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/6/22.
//

import Foundation

struct CalorieDatabase
{
    var database : [Int] = []
    
    mutating func insert(_ value: Int) {
        database.append(value)
        database.sort()
    }
    
    func getMax(count : Int) -> [Int] {
        return Array(database[database.count - count ..< database.count])
    }
}

func parseInputFileCalories(_ filename: String) -> CalorieDatabase?
{
    guard let file = freopen(filename, "r", stdin) else {
        print("Cannot open file")
        return nil
    }
    defer {
        fclose(file)
    }
    
    var database = CalorieDatabase()
    var calories : Int = 0
    while let line = readLine()
    {
        if(line.isEmpty){
            database.insert(calories)
            calories = 0
        }
        else{
            guard let inputCal = Int(line) else {
                print("Invalid line in file:")
                print(line)
                return nil
            }
            calories += inputCal
        }
    }
    
    if(calories > 0)
    {
        database.insert(calories)
        calories = 0
    }
    
    return database
}

func maxCalorieFinder(_ files: [String])
{
    for file in files
    {
        print("Parsing file: \(file)")
        guard let database = parseInputFileCalories(file) else {
            print("could not get database")
            continue
        }
        let maxArray = database.getMax(count:3)
        let max = maxArray.reduce(0, +)
        
        print("The max calories a single person has from the group in \(file) is \(max)")
    }
}
