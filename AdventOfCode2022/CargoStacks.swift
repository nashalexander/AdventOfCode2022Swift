//
//  CargoStacks.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/6/22.
//

import Foundation

struct CraneInstruction
{
    var quantity : Int
    var startStack : Int
    var endStack : Int
}

struct CargoStacks
{
    var stacks : [[Character]] = []
    
    func getTopCrates() -> String
    {
        var str = ""
        for stack in stacks
        {
            if let top = stack.first {
                str.append(top)
            }
        }
        return str
    }
    
    mutating func stackBox(_ stack : Int, _ box : Character)
    {
        while stack > stacks.count - 1
        {
            stacks.append([])
        }
        
        stacks[stack].append(box)
    }
    
    mutating func doInstruction(_ instruction : CraneInstruction) throws
    {
        if(stacks.count < instruction.startStack || stacks.count < instruction.endStack)
        {
            throw NSError()
        }
        if(stacks[instruction.startStack - 1].count < instruction.quantity)
        {
            throw NSError()
        }
        
        for i in 0..<instruction.quantity
        {
            stacks[instruction.endStack - 1].insert(stacks[instruction.startStack - 1].removeFirst(), at: i)
        }
    }
}

struct CargoEnvironment
{
    var cargoStacks : CargoStacks
    var instructions : [CraneInstruction]
    
    mutating func doInstructions() throws
    {
        for instruction in instructions
        {
            try! cargoStacks.doInstruction(instruction)
        }
    }
}

func parseInstruction(_ str : String) -> CraneInstruction?
{
    let syntaxArray = str.components(separatedBy: " ")
    
    if(syntaxArray[0] == "move")
    {
        guard let quantity = Int(syntaxArray[1]) else {
            print("Invalid move arg: \(syntaxArray[1])")
            return nil
        }
        
        assert(syntaxArray[2] == "from")
        guard let start = Int(syntaxArray[3]) else {
            print("Invalid from arg: \(syntaxArray[3])")
            return nil
        }
        
        assert(syntaxArray[4] == "to")
        guard let end = Int(syntaxArray[5]) else {
            print("Invalid to arg: \(syntaxArray[5])")
            return nil
        }
        
        return CraneInstruction(quantity: quantity, startStack: start, endStack: end)
        
    }
    else
    {
        print("Unknown instruction: \(syntaxArray[0])")
        return nil
    }
}

func createEnvironment(_ strArray : [String]) -> CargoEnvironment?
{
    var stacks = CargoStacks()
    var instructions : [CraneInstruction]  = []
    
    var instructionPhase = false
    for str in strArray
    {
        if(str.isEmpty)
        {
            instructionPhase = true
            continue
        }
        
        if(instructionPhase)
        {
            if let instruction = parseInstruction(str) {
                instructions.append(instruction)
            }
            continue
        }
        
        var index = str.startIndex
        var spaceCounter = 0
        var stackCounter = 0
        while index < str.endIndex
        {
            if(str[index] == " ")
            {
                spaceCounter += 1
            }
            else if(str[index] == "[")
            {
                spaceCounter = 0
                index = str.index(index, offsetBy: 1)
                stacks.stackBox(stackCounter, str[index])
                stackCounter += 1
                
                index = str.index(index, offsetBy: 1)
                assert(str[index] == "]")
            }
            else
            {
                // We must be on the number row, lets blow through this line
                while index < str.endIndex
                {
                    if(str[index] == " ")
                    {
                        index = str.index(index, offsetBy: 1)
                        continue
                    }
                    guard let num = str[index].wholeNumberValue else {
                        print("Invalid character in cargo stacks: \(str[index])")
                        return nil
                    }
                    while(stacks.stacks.count < num)
                    {
                        stacks.stacks.append([])
                    }
                    index = str.index(index, offsetBy: 1)
                }
                continue
            }
            
            if(spaceCounter >= 3)
            {
                stackCounter += 1
                spaceCounter = 0
            }
            
            index = str.index(index, offsetBy: 1)
        }
    }
    
    return CargoEnvironment(cargoStacks: stacks, instructions: instructions)
}

func craneOperator(_ strArray : [String]) throws
{
    guard var env = createEnvironment(strArray) else {
        print("Unable to gen env")
        throw NSError()
    }
    
    try! env.doInstructions()
    
    let topCrateStr = env.cargoStacks.getTopCrates()
    
    print("The top crates of the stacks are: \(topCrateStr)")
}
