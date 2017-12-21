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


