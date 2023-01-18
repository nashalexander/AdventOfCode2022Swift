//
//  main.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/1/22.
//

import Foundation

// Common

/*
// For when I want to use a bundle
 var arrayOfStrings: [String]?

     do {
         // This solution assumes  you've got the file in your bundle
         if let path = Bundle.main.path(forResource: "YourTextFilename", ofType: "txt"){
             let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
             arrayOfStrings = data.components(separatedBy: "\n")
             print(arrayOfStrings)
         }
     } catch let err as NSError {
         // do something with Error
         print(err)
     }
*/

func serializeFile(_ filename : String) -> [String]?
{
    guard let file = freopen(filename, "r", stdin) else {
        print("Cannot open file \(filename)")
        return nil
    }
    defer {
        fclose(file)
    }
    
    var strArray : [String] = []
    
    while let line : String = readLine()
    {
        strArray.append(line)
    }
    
    return strArray
}

func getInputFiles() -> [String]
{
    if(CommandLine.arguments.count < 2)
    {
        print("This app requires an input file")
        exit(1)
    }
    
    var args = CommandLine.arguments
    args.remove(at: 0)
    
    return args
}


func main()
{
    let files = getInputFiles()
    
    for file in files
    {
        if let input = serializeFile(file) {
            try! doCum(input)
        }
    }
}
main()
