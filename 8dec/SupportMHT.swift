//
//  SupportMHT.swift
//  8dec
//
//  Created by Mats Hammarqvist on 2017-12-12.
//  Copyright © 2017 Mats Hammarqvist. All rights reserved.
//

import Foundation

/*func toString( dateFormat format  : String ) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
}
 

}
 */

func getKnotHash(withString:String)-> String {
    
    // SETUPP
    let indataLengthString = withString //= "63,144,180,149,1,255,167,84,125,65,188,0,2,254,229,24"
    
    var indataLength = [Int]()
    
    //let characterString: String = indataLengthString
    
    for character in indataLengthString.utf8 {
        let stringSegment: String = "\(character)"
        let anInt = Int(stringSegment)
        indataLength.append(anInt!)
    }
    
    
    
    
    
    
    
    /*
     
     var indataChars = [Character]()
     var tempIndataChars = [Character]()
     
     // Fyll indataChars med alla tecken i indata
     for char in indata{
     indataChars.append(char)
     }
     
     */
    
    let step2 = [17, 31, 73, 47, 23]
    
    indataLength += step2 //Lägg på det som krävs i uppgift
    
    
    
    //var indataLength = [3, 4, 1, 5]
    var skipSize = 0
    var currentPosition = 0
    
    var circleOfTrust = [Int]()
    
    for index in 0...255 {
        circleOfTrust.append(index)
    }
    // END SETUP
    for _ in 0...63{
        for indataLengthIndex in 0...indataLength.count-1{  // byt till indataLength.count-1
            var tempArray = [Int]()
            let sectionLength = indataLength[indataLengthIndex]
            if sectionLength > 0 {
                for tempArrayIndex in 0...sectionLength-1{
                    let myPointer = (currentPosition + tempArrayIndex) % (circleOfTrust.count)
                    tempArray.append(circleOfTrust[myPointer])
                }
                tempArray = reverseArray(LengthArray: tempArray) //flip array
                
                
                for tempArrayIndex in 0...sectionLength-1{
                    let myPointer = (currentPosition + tempArrayIndex) % (circleOfTrust.count)
                    circleOfTrust[myPointer] = tempArray[tempArrayIndex]
                }
            }
            currentPosition =  ((currentPosition + sectionLength + skipSize) % (circleOfTrust.count))
            skipSize += 1
            
           // print("current: \(currentPosition)")
        }
        
    }
    
   // print(circleOfTrust)
    let sparseHash = circleOfTrust
    
    var denseHash = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    
    for indexBlock in 0...15{
        for indexInBlock in 0...15{
            denseHash[indexBlock] = denseHash[indexBlock]^sparseHash[indexBlock*16+indexInBlock]
        }
    }
   // print(denseHash)
    
    var knotHash = ""
    for indexInDenseHash in 0...denseHash.count - 1{
        
        var häxan = String(denseHash[indexInDenseHash], radix: 16)
        
        if häxan.count < 2{
            häxan = "0" + häxan
        }
        
        knotHash = knotHash + häxan
        
    }
    
   return knotHash

    
}

func colonSeparated(data: String) -> [[String]] {
    // Dela upp strängen i rader och kolumner
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    
    // print(rows)
    
    for row in rows {
        let columns = row.components(separatedBy: ":") //tab-separerad
        result.append(columns)
    }
    return result
}
func csv(data: String) -> [[String]] {
    // Dela upp strängen i rader och kolumner
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    
    //print(rows)
    
    for row in rows {
        let columns = row.components(separatedBy: ",")
        result.append(columns)
    }
    return result
}
func spaceSeparated(data: String) -> [[String]] {
    // Dela upp strängen i rader och kolumner
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    
    // print(rows)
    
    for row in rows {
        let columns = row.components(separatedBy: " ") //tab-separerad
        result.append(columns)
    }
    return result
}


func tabSeparated(data: String) -> [[String]] {
    // Dela upp strängen i rader och kolumner
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    
    // print(rows)
    
    for row in rows {
        let columns = row.components(separatedBy: "\t") //tab-separerad
        result.append(columns)
    }
    return result
}


func reverseArray(LengthArray: [Int])-> [Int]{
    var tempArray=[Int]()
    
    for index in 0...LengthArray.count - 1 {
        tempArray.append(LengthArray[LengthArray.count-index-1])
    }
    return tempArray
}

func csvArray(data: String) -> [String] {
    
    var result: [String] = []
    
    
    // print(rows)
    
    
    result = data.components(separatedBy: ",")
    
    return result // resultat blir arrayen som vi jobbar på -> indata nedan
}


//Läs in fil

func readFile(fileName:String)->[[String]]{
let fileURL = Bundle.main.url(forResource:fileName, withExtension: "txt")

// print("\(String(describing: fileURL))")
var fileData:String?

do {
    fileData = try String(contentsOf: fileURL!)
    // print(fileData!)
    
} catch {
    print(error.localizedDescription)
}
    let Indata = spaceSeparated(data: fileData!)
return Indata
// print(Indata)

//print(Indata.count)
// print(Indata[1].count)

}


