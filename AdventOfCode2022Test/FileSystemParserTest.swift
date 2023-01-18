//
//  FileSystemParserTest.swift
//  AdventOfCode2022Test
//
//  Created by Alex on 12/16/22.
//

import XCTest

class FileSystemParserTest: XCTestCase {

    func testProcessCd() throws {
        let input = "home"
        var path : [Directory] = [Directory(name: "/")]
        
        processCd(&path, input)
        
        XCTAssertEqual(2, path.count)
        
        guard let currDir = path.last else {
            XCTFail()
            return
        }
        
        XCTAssertEqual("home", currDir.name)
    }
    
    func testProcessLs() throws {
        let output = [
            "123 file1",
            "dir firstDir",
            "321 file2",
            "dir secondDir"
        ]
        var path : [Directory] = [Directory(name: "/")]
        
        do {
            try processLs(&path, output)
        } catch {
            XCTFail()
        }
        
        guard let currDir = path.last else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(444, currDir.localFileSize)
        XCTAssertEqual(2, currDir.subDirs.count)
        XCTAssertEqual("firstDir", currDir.subDirs[0].name)
        XCTAssertEqual("secondDir", currDir.subDirs[1].name)
    }
    
    func testGetRootDir() throws {
        let input = [
            "$ cd /",
            "$ ls",
            "dir a",
            "14848514 b.txt",
            "8504156 c.dat",
            "dir d",
            "$ cd a",
            "$ ls",
            "dir e",
            "29116 f",
            "2557 g",
            "62596 h.lst",
            "$ cd e",
            "$ ls",
            "584 i",
            "$ cd ..",
            "$ cd ..",
            "$ cd d",
            "$ ls",
            "4060174 j",
            "8033020 d.log",
            "5626152 d.ext",
            "7214296 k"
        ]
        
        var rootDir : Directory
        do{
            try rootDir = getRootDir(input)
            XCTAssertEqual(48381165, rootDir.getTotalFileSize())
            XCTAssertEqual(95437, rootDir.getTotalCumFileSize(dirMaxSize: 100_000))
            
            guard let dir = rootDir.getDirToDelete(dirMinSize: 300_000) else {
                XCTFail()
                return
            }
            XCTAssertEqual("d", dir.name)
            XCTAssertEqual(24933642, dir.getTotalFileSize())
        }
        catch{
            XCTFail()
        }
    }
    
    func testFuncDeleteDir() throws{
        let input = [
            "$ cd /",
            "$ ls",
            "dir a",
            "14848514 b.txt",
            "8504156 c.dat",
            "dir d",
            "$ cd a",
            "$ ls",
            "dir e",
            "29116 f",
            "2557 g",
            "62596 h.lst",
            "$ cd e",
            "$ ls",
            "584 i",
            "$ cd ..",
            "$ cd ..",
            "$ cd d",
            "$ ls",
            "4060174 j",
            "8033020 d.log",
            "5626152 d.ext",
            "7214296 k"
        ]
    }

}
