//
//  RuckSack.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/4/22.
//

import Foundation

// Day 3

func getItemPriority(_ item: Character) -> Int?
{
    let baseValueLowercase = Character("a").asciiValue! - 1
    let baseValueUppercase = Character("A").asciiValue! - 27
    
    if let asciiVal = item.asciiValue {
        if(item.isLowercase){
            return Int(asciiVal - baseValueLowercase)
        }
        else if(item.isUppercase){
            return Int(asciiVal - baseValueUppercase)
        }
        else{
            return nil
        }
    }
    else{
        return nil
    }
}

class RuckSack
{
    var compartments : String {
        didSet {
            if(compartments.count % 2 != 0){
                print("Bad set of non even string: \(compartments)")
                compartments = ""
            }
        }
    }
    
    init(_ compartments: String)
    {
        self.compartments = compartments
    }
    
    func getComparment(_ firstCompartment: Bool) -> String
    {
        let half = compartments.count/2
        
        if(firstCompartment){
            return String(compartments.prefix(half))
        }
        else{
            return String(compartments.suffix(half))
        }
    }
    
    func getDupe() -> Character?
    {
        var items : Set<Character> = []
        let firstCompartment = getComparment(true)
        let secondCompartment = getComparment(false)
        
        var dupe : Character? = nil
        
        for char : Character in firstCompartment{
            items.insert(char)
        }
        
        for char : Character in secondCompartment{
            if(items.contains(char) && dupe != char){
                if(dupe != nil){
                    print("Mutiple dupes detected: \(String(describing: dupe)) and \(char)")
                    return nil
                }
                dupe = char
            }
        }
        
        return dupe
    }
}

class RuckSackTroop
{
    var allRucksacks : [RuckSack] = []
    
    func insert(_ sack: RuckSack){
        allRucksacks.append(sack)
    }
    
    func getTotalPriorityOfDupes() -> Int
    {
        var totalPriority : Int = 0
        for sack in allRucksacks {
            guard let dupe = sack.getDupe() else {
                print("bad sack: \(sack.compartments)")
                continue
            }
            
            guard let priority = getItemPriority(dupe) else {
                print("Bad item char: \(dupe)")
                continue
            }
            
            totalPriority += priority
        }
        return totalPriority
    }
    
    func getCommonItem() -> Character?
    {
        var set : Set<Character> = []
        
        for sack in allRucksacks{
            var tmpSet : Set<Character> = []
            for item in sack.compartments{
                tmpSet.insert(item)
            }
            if(set.isEmpty){
                set = tmpSet
            }
            else{
                set = set.intersection(tmpSet)
            }
        }
        
        if(set.count != 1){
            print("Common set count is \(set.count), but there should only be 1")
            return nil
        }
        else{
            return set.first
        }
    }
}


func getRuckSacks(_ filename: String) -> RuckSackTroop?
{
    guard let file = freopen(filename, "r", stdin) else {
        print("Cannot open file")
        return nil
    }
    defer {
        fclose(file)
    }
    
    let troop = RuckSackTroop()
    while let line : String = readLine()
    {
        troop.insert(RuckSack(line))
    }

    return troop
}

func getGroupOfRuckSacks(_ filename : String) -> [RuckSackTroop]?
{
    let groupSize = 3
    
    guard let file = freopen(filename, "r", stdin) else {
        print("Cannot open file")
        return nil
    }
    defer {
        fclose(file)
    }
    
    var troops : [RuckSackTroop] = []
    var troop = RuckSackTroop()
    
    while let line : String = readLine()
    {
        troop.insert(RuckSack(line))
        
        if(troop.allRucksacks.count >= groupSize){
            troops.append(troop)
            troop = RuckSackTroop()
        }
    }

    return troops
}


func ruckSackPriorityCalculator(_ files: [String])
{
    for file in files{
        let troop = getRuckSacks(file)
        
        let value = troop!.getTotalPriorityOfDupes()
        
        print("The total priority of dupes from file \(file) is \(value)")
    }
}

func ruckSackCommonItemCalculator(_ files: [String]){
    for file in files{
        let troops = getGroupOfRuckSacks(file)!
        
        var totalPriority = 0
        for troop in troops{
            guard let item = troop.getCommonItem() else{
                continue
            }
            guard let priority = getItemPriority(item) else{
                continue
            }
            totalPriority += priority
        }
        
        print("The total priority of the common items from file \(file) is \(totalPriority)")
    }
}
