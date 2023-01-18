//
//  FileSystemParser.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/16/22.
//

import Foundation

class Directory
{
    var name : String
    var localFileSize : Int = 0
    var subDirs : [Directory] = []
    
    init(name : String)
    {
        self.name = name
    }
    
    func getTotalFileSize() -> Int
    {
        var size = localFileSize
        for dir in subDirs
        {
            size += dir.getTotalFileSize()
        }
        return size
    }
    
    func getTotalCumFileSize(dirMaxSize : Int) -> Int
    {
        var size = 0
        let totalFileSize = getTotalFileSize()
        if(totalFileSize < dirMaxSize){
            size += totalFileSize
        }
        for dir in subDirs
        {
            size += dir.getTotalCumFileSize(dirMaxSize: dirMaxSize)
        }
        return size
    }
    
    func getDirToDelete(dirMinSize: Int) -> Directory?
    {
        if(getTotalFileSize() >= dirMinSize){
            var smallestDir = self
            for dir in subDirs{
                if let closestDir = dir.getDirToDelete(dirMinSize: dirMinSize){
                    if(closestDir.getTotalFileSize() < smallestDir.getTotalFileSize()){
                        smallestDir = dir
                    }
                }
            }
            return smallestDir
        }
        return nil
    }
    
    func getDirsBigEnough(dirMinSize: Int) -> [Directory]
    {
        var dirs : [Directory] = []
        if(getTotalFileSize() > dirMinSize){
            dirs.append(self)
        }
        for dir in subDirs{
            dirs.append(contentsOf: dir.getDirsBigEnough(dirMinSize: dirMinSize))
        }
        return dirs
    }
}

func processCd(_ path : inout [Directory], _ input : String)
{
    if(input == "..")
    {
        assert(path.count > 1)
        _ = path.popLast()
    }
    else if(input == "/")
    {
        path = [path.first!]
    }
    else
    {
        let currentDir = path.last!
        if let nextDir = currentDir.subDirs.first(where: {dir in return dir.name == input})
        {
            path.append(nextDir)
        }
        else
        {
            let newDir = Directory(name: input)
            currentDir.subDirs.append(newDir)
            path.append(newDir)
        }
    }
}

func processLs(_ path : inout [Directory], _ output : [String]) throws
{
    let currentDir = path.last!
    for str in output
    {
        let comps = str.components(separatedBy: " ")
        
        assert(comps.count == 2)
        if(comps[0] == "dir")
        {
            let dirName = comps[1]
            if(currentDir.subDirs.first(where: {dir in return dir.name == dirName}) == nil)
            {
                let newDir = Directory(name: dirName)
                currentDir.subDirs.append(newDir)
            }
        }
        else if let dataValue = Int(comps[0]) {
            currentDir.localFileSize += dataValue
        }
        else {
            print("Invalid ls input detected")
            throw NSError()
        }
    }
}

func getRootDir(_ commands : [String]) throws -> Directory
{
    let rootDir = Directory(name: "/")
    var currentPath : [Directory] = [rootDir]
    
    var index = 0
    while index < commands.count
    {
        let comps = commands[index].components(separatedBy: " ")
        if(comps[0] == "$")
        {
            if(comps[1] == "cd")
            {
                processCd(&currentPath, comps[2])
            }
            else if(comps[1] == "ls")
            {
                var output : [String] = []
                while(commands.count > (index + 1) && commands[index + 1].components(separatedBy: " ")[0] != "$")
                {
                    index += 1
                    output.append(commands[index])
                }
                do{
                    try processLs(&currentPath, output)
                }
                catch{
                    print("process ls failed with ls output of \(output)")
                    throw NSError()
                }
            }
        }
        else
        {
            print("Non command line not caught")
            throw NSError()
        }
        
        index += 1
    }
    
    return rootDir
}

func getDirToHaveFreeSpaceNeeded(rootDir : Directory, maxSpace : Int, spaceNeeded : Int) -> Directory?
{
    let spaceToFree = rootDir.getTotalFileSize() + spaceNeeded - maxSpace
    if(spaceToFree <= 0)
    {
        return nil
    }
    
    let deleteThisDir = rootDir.getDirToDelete(dirMinSize: spaceToFree)
    
    return deleteThisDir
}

func getDirBigEnough(rootDir : Directory, maxSpace : Int, spaceNeeded : Int) -> [Directory]
{
    var dirs : [Directory] = []
    let spaceToFree = rootDir.getTotalFileSize() + spaceNeeded - maxSpace
    if(spaceToFree <= 0)
    {
        return dirs
    }
    dirs = rootDir.getDirsBigEnough(dirMinSize: spaceToFree)
    return dirs
}

func doCum(_ strArray : [String]) throws
{
    do{
        let rootDir = try getRootDir(strArray)
        let value = rootDir.getTotalCumFileSize(dirMaxSize: 100000)
        print("Cum size of max 100,000 is \(value)")
        
        guard let dir = getDirToHaveFreeSpaceNeeded(rootDir: rootDir, maxSpace: 70_000_000, spaceNeeded: 30_000_000) else {
            print("Enough free space exists, no dir needs to be deleted")
            return
        }
        print("Dir to delete: \(dir.name) of size: \(dir.getTotalFileSize())")
        
        let dirs = getDirBigEnough(rootDir: rootDir, maxSpace: 70_000_000, spaceNeeded: 30_000_000)
        print("All dirs big enough to help:")
        for d in dirs{
            print("name: \(d.name) size: \(d.getTotalFileSize())")
        }
    }
    catch{
        throw NSError()
    }
}
