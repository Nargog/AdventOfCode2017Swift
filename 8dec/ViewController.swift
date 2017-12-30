//
//  ViewController.swift
//  8dec
//
//  Created by Mats Hammarqvist on 2017-12-11.
//  Copyright © 2017 Mats Hammarqvist. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func btn19dec(_ sender: Any) {
        var test = ""
        var myPointer:(rowValue: Int, columnValue: Int)
        myPointer.columnValue = 0; myPointer.rowValue = 0
        
        var direction:(rowDirection: Int , columnDirection: Int )
        direction.columnDirection = 0 ; direction.rowDirection = 1
    
        let input = myGetStringFromFile(filename: "dec19")
        
        var myMaze = [[Character]]()
        var stop = false
        
        myMaze = splitIntoRowsandCharachters(data: input)
        
       // print(myMaze)
        // get startPoint
        for index in 0...myMaze[0].count-1 {
            print(myMaze[0][index])
            if myMaze[0][index] == "|" {myPointer.columnValue = index; myPointer.rowValue = 0}
        }
       var antalSteps = 0
        while !stop {
        antalSteps += 1
        switch myMaze[myPointer.rowValue][myPointer.columnValue] {
        case "+":
            print("+")
            if myMaze[myPointer.rowValue + direction.columnDirection][myPointer.columnValue + direction.rowDirection] == " "{
                let tempDirection = direction.rowDirection
                direction.rowDirection = -1 * direction.columnDirection
                direction.columnDirection = -1 * tempDirection
            } else {
                let tempDirection = direction.rowDirection
                direction.rowDirection =  direction.columnDirection
                direction.columnDirection = tempDirection
            }
        case "|":
            print("| keep on")
        case "-":
            print("- keep on")
        case " ":
            print("  -stop")
            stop = true
        default:
            test = test + "\(myMaze[myPointer.rowValue][myPointer.columnValue])"
            print("\(myMaze[myPointer.rowValue][myPointer.columnValue]) keep on")
        }
            myPointer.rowValue += direction.rowDirection
            myPointer.columnValue += direction.columnDirection
        }
        
        print("Ordet är : \(test) och steg: \(antalSteps-1)")
    }
    
    
    
    @IBAction func btn18dec(_ sender: Any) {
        
        let fileURL = Bundle.main.url(forResource:"dec18", withExtension: "txt")
        
        // print("\(String(describing: fileURL))")
        var fileData:String?
        
        do {
            fileData = try String(contentsOf: fileURL!)
            // print(fileData!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        var noSentFromP1 = 0
        var commandArray = spaceSeparated(data: fileData!)
        
        var P0waitingforInput = false
        var P1waitingforInput = false
        
        var sndOutP0 = [Int]()
        var sndOutP1 = [Int]()
        
        let registersInput = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p"
        
        let result = registersInput.components(separatedBy: ",")
        
        var registersP0 = [String:Int]()
        var registersP1 = [String:Int]()
        
        for register in result {
            registersP0[register] = 0
            registersP1[register] = 0
        }
       
        registersP1["p"] = 1
        print(registersP1)
        
        
        var pointerP0 = 0
        var pointerP1 = 0
        
        //    registers
        
        //Setup complete
        
        
        func Program1() {
            while pointerP1 < commandArray.count && pointerP1 >= 0 {
                switch commandArray[pointerP1][0]{
                case "set":
                   // print("set")
                    registersP1[commandArray[pointerP1][1]] = (Int(commandArray[pointerP1][2]) ?? registersP1[commandArray[pointerP1][2]]!)
                    pointerP1 += 1
                    
                case "add":
                   // print("add")
                    registersP1[commandArray[pointerP1][1]] = (Int(commandArray[pointerP1][2]) ?? registersP1[commandArray[pointerP1][2]]!) + registersP1[commandArray[pointerP1][1]]!
                    pointerP1 += 1
                case "mul":
                   // print("mul")
                    registersP1[commandArray[pointerP1][1]] = (Int(commandArray[pointerP1][2]) ?? registersP1[commandArray[pointerP1][2]]!)  * registersP1[commandArray[pointerP1][1]]!
                    pointerP1 += 1
                case "mod":
                 //   print("mod")
                    registersP1[commandArray[pointerP1][1]] = registersP1[commandArray[pointerP1][1]]! % (Int(commandArray[pointerP1][2]) ?? registersP1[commandArray[pointerP1][2]]!)
                    pointerP1 += 1
                case "snd":
                   // print("snd")
                    sndOutP1.append(registersP1[commandArray[pointerP1][1]]!)
                    pointerP1 += 1
                    noSentFromP1 += 1
                    print("No sent numbers : \(noSentFromP1)")
                    P0waitingforInput = false
                    return
                case "rcv":
                   // print("rcv")
                    
                    //    print(sndOutP1)
                        if sndOutP0.isEmpty {
                            P1waitingforInput = true
                            if P0waitingforInput {
                                pointerP1 = -99
                            }
                            return
                        } else {
                        registersP1[commandArray[pointerP1][1]] = sndOutP0.remove(at: 0)
                        pointerP1 += 1
                        
                        }
                    
                    
                case "jgz":
                //    print("jgz")
                    if registersP1[commandArray[pointerP1][1]] ?? Int(commandArray[pointerP1][1])! > 0
                    {pointerP1 += Int(commandArray[pointerP1][2]) ?? registersP1[commandArray[pointerP1][1]]! }
                    else {
                        pointerP1 += 1
                    }
                default:
                    print("ooops")
                    
                }
            }
            //return
        }
        
        //import PlaygroundSupport // Gör så att man kan spara alla filer man behöver i ett och samma bibliotek
        
        print(registersP0)
        
        while pointerP0 < commandArray.count && pointerP0 >= 0 {
            switch commandArray[pointerP0][0]{
            case "set":
              
                registersP0[commandArray[pointerP0][1]] = (Int(commandArray[pointerP0][2]) ?? registersP0[commandArray[pointerP0][2]]!)
                
            //    print("set")
                //print(registersP0.count)
                pointerP0 += 1
                
            case "add":
            //    print("add")
                registersP0[commandArray[pointerP0][1]] = (Int(commandArray[pointerP0][2]) ?? registersP0[commandArray[pointerP0][2]]!) + registersP0[commandArray[pointerP0][1]]!
                pointerP0 += 1
            case "mul":
            //    print("mul")
                registersP0[commandArray[pointerP0][1]] = (Int(commandArray[pointerP0][2]) ?? registersP0[commandArray[pointerP0][2]]!)  * registersP0[commandArray[pointerP0][1]]!
               // print(registersP0)
                pointerP0 += 1
            case "mod":
             //   print("mod")
                registersP0[commandArray[pointerP0][1]] = registersP0[commandArray[pointerP0][1]]! % (Int(commandArray[pointerP0][2]) ?? registersP0[commandArray[pointerP0][2]]!)
               // print(registersP0)
                pointerP0 += 1
            case "snd":
            //    print("snd")
                sndOutP0.append(registersP0[commandArray[pointerP0][1]]!)
                
             //   print(registersP0.count)
                pointerP0 += 1
                P1waitingforInput = false
                Program1()
            case "rcv":
            //    print("rcv")
                
             //       print(sndOutP0.count)
                    if sndOutP1.isEmpty {
                        P0waitingforInput = true
                        if P1waitingforInput {pointerP0 = -99}
                        Program1()
                      //  print("one hop")
                    } else {
                        registersP0[commandArray[pointerP0][1]] = sndOutP1.remove(at: 0)
                        pointerP0 += 1
                }
                        
                    
                
                
            case "jgz":
            //    print("jgz")
                if registersP0[commandArray[pointerP0][1]] ?? Int(commandArray[pointerP0][1])! > 0
                {pointerP0 += Int(commandArray[pointerP0][2]) ?? registersP0[commandArray[pointerP0][1]]! }
                else {
                    pointerP0 += 1
                }
           //     print("pointerP0 \(pointerP0)")
            default:
                print("ooops")
                
            }
        }
        
   //     print(registersP0)
        

        
    }
    
    
    
    @IBAction func btn17decsteg2(_ sender: Any) {
        var result = 0
        var inputString = 1
        var inputStringLength = 1
        var position = 0
        let puzzleInput  = 304
       // let inputLine:[String] = ["0"] //["3","0","4"]
        let numberOfInputs = 50000000
        
        for index in 1...numberOfInputs {
            position += puzzleInput
            position = position % inputStringLength
            
            
            if position == 0 { result = index}
            position += 1
            inputStringLength += 1
            
            
            
            //print(inputLine)
            inputString += 1
        }
        //print(inputLine[position + 1])
        
        print(result)
        
    }
    @IBAction func btn17dec(_ sender: Any) {
        var inputString = 1
        var position = 0
        let puzzleInput = 304
        var inputLine:[String] = ["0"] //["3","0","4"]
        let numberOfInputs = 50000000
        
        for index in 1...numberOfInputs {
            position += puzzleInput
            position = position % inputLine.count
            
            if position == inputLine.count - 1 {
                inputLine.append("\(index)")
                position += 1
            } else {
                
            position += 1
            inputLine.insert("\(index)", at: position)
            
            
            }
            //print(inputLine)
            inputString += 1
        }
        print(inputLine[position + 1])
        
        for findZeroIndex in 0...inputLine.count - 1{
            if inputLine[findZeroIndex] == "0" { print(inputLine[(findZeroIndex + 1) % inputLine.count])}
        }
        //0 (9) 5  7  2  4  3  8  6  1
    }
    
    @IBAction func btn16dec(_ sender: Any) {
        
        func separateString(inputString: String, withSeparator:String) -> [String] {
            // Dela upp strängen i rader och kolumner
            var result = [String]()
            result = inputString.components(separatedBy: withSeparator)
            
            
            return result
        }
        let fileURL = Bundle.main.url(forResource:"dec16", withExtension: "txt")
        
        // print("\(String(describing: fileURL))")
        var fileData:String?
        
        do {
            fileData = try String(contentsOf: fileURL!)
            // print(fileData!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        let indataArray = separateString(inputString: fileData!, withSeparator: ",")
        
     
        
        let dancersString = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p"
        var dancersArray = separateString(inputString: dancersString, withSeparator: ",")
        let dancersArrayStart = dancersArray
       var matchIndex = 0
        var tempDancers = [String]()
        var dancersArrayCollection = [[String]]()
        var indexSwap = ["q","q"]
        var stringSwap = ["q","q"]
        var tempString = ""
        var inputline = ""
     
        
        for numberOfDancesIndex in 1...31 {
        
        for test in indataArray {
            inputline = test
            //var operation = "\(inputline.first ?? "q")"
            switch  inputline.remove(at: inputline.startIndex) {
            case "s":
                //print("s")
                
                for index in (dancersArray.count - Int(inputline)!)...dancersArray.count-1{
                    tempDancers.append( dancersArray[index])
                }
                for index in 0...(dancersArray.count - 1 - Int(inputline)!){
                    tempDancers.append( dancersArray[index])
                }
                dancersArray = tempDancers
                tempDancers.removeAll()
                
            case "x" :
                //print("x")
                indexSwap = separateString(inputString: inputline, withSeparator: "/")
                tempString = dancersArray[Int(indexSwap[0])!]
                dancersArray[Int(indexSwap[0])!] = dancersArray[Int(indexSwap[1])!]
                dancersArray[Int(indexSwap[1])!] = tempString
            case "p":
                stringSwap = separateString(inputString: inputline, withSeparator: "/")
                for index in 0...dancersArray.count - 1 {
                    if stringSwap[0] == dancersArray[index]{indexSwap[0] = String(index)}
                    if stringSwap[1] == dancersArray[index]{indexSwap[1] = String(index)}
                }
                tempString = dancersArray[Int(indexSwap[0])!]
                dancersArray[Int(indexSwap[0])!] = dancersArray[Int(indexSwap[1])!]
                dancersArray[Int(indexSwap[1])!] = tempString
                //print("p")
            default:
                print("oops")
            
        }
        
         
        }
             print(dancersArray)
           dancersArrayCollection.append(dancersArray)
            if dancersArray == dancersArrayStart {
                print(numberOfDancesIndex)
                matchIndex = numberOfDancesIndex}
            //print(dancersArray)
        }
        
        
        // -------------------------------
        
        
    
    var utstring = ""
    
    for texken in dancersArrayCollection[(1000000000 % matchIndex)-1]{
    utstring += texken
        }
        
        print(utstring)
        print(dancersArrayCollection[(1000000000 % matchIndex)-1])
        
/*        var differensArray = [Int]()
        var dancersArrayTemp =  [String]()
        
        
     //   for _ in 1...9 {
        
             differensArray.removeAll()
        for tecken in dancersArray {
            for index in 0...dancersArrayStart.count - 1 {
                if tecken == dancersArrayStart[index] { differensArray.append(index)}
                
            }
        }
        
  /*      print("difference over one dance. The new position gets value from last position: \(differensArray)")
        dancersArray = dancersArrayStart
        
        for _ in 1...20 {
            for index in 0...dancersArrayStart.count - 1 {
                dancersArrayTemp.append(dancersArray[differensArray[index]])
            }
            dancersArray = dancersArrayTemp
            print(dancersArray)
            dancersArrayTemp.removeAll()
        }
            
      */
        
        print(dancersArray)
        
        utstring = ""
        for texken in dancersArray{
            utstring += texken
        }
        
        print("weird the dance get cyclic every 10th time. Why isnt the answer : \(utstring)")
        //answer jkmflcgpdbonihea */

        
    }
    
    
    @IBAction func btn15dec(_ sender: Any) {
        
        var compareA = ""
        var compareB = ""
        
        var compareAStep2 = [String]()
        var compareBStep2 = [String]()
        
        var generatorA = 116
        var generatorB = 299
        
        var nextGeneratorA = 0
        var nextGeneratorB = 0
        
        let factorA = 16807
        let factorB = 48271
        
        let divisor = 2147483647
        var antalMatch = 0
        
        var foundBForEval = false
        var foundAForEval = false
        
        let antalTests = 5000000
        
        while  compareAStep2.count < antalTests || compareBStep2.count < antalTests{
            
            nextGeneratorA = generatorA*factorA%divisor
            nextGeneratorB = generatorB*factorB%divisor
            
            if nextGeneratorA%4 == 0 {foundAForEval = true}
            if nextGeneratorB%8 == 0 {foundBForEval = true}
            
            compareA = String(nextGeneratorA, radix:2)
            while compareA.count < 16 {
                compareA = "0"+compareA
            }
            
            
            compareB = String(nextGeneratorB, radix:2)
            while compareB.count < 16 {
                compareB = "0"+compareB
            }
            
            
            
            compareA = String(compareA.suffix(16))
            compareB = String(compareB.suffix(16))
            
            if foundAForEval{
                compareAStep2.append(compareA)
                foundAForEval = false
            }
            if foundBForEval{
                compareBStep2.append(compareB)
                foundBForEval = false
            }
            
            
            if compareB == compareA { antalMatch += 1}
            
            generatorA = nextGeneratorA
            generatorB = nextGeneratorB
            
        }
        
        print("Antal match: \(antalMatch)")
        
        
        //test the antalTests number of pairs in compareXStep2[] (5 milj)
        var hitStep2 = 0
        for index in 0...antalTests - 1 {
            if compareAStep2[index] == compareBStep2[index] {
                
                hitStep2 += 1
                print(hitStep2)
            }
            
        }
        
    }
    @IBAction func btn14Dec(_ sender: Any) {
        var BinaryKnotHashRow = [String]()
        var knotHashes = [[String]]()
        var antalEttor = 0
        
        func findAndMarkNeighbour (row: Int, column:Int, regionNumber:Int){
            knotHashes[row][column] = String(regionNumber)
            
            //up
            if row > 0 {
                if knotHashes[row-1][column] == "#"{
                    findAndMarkNeighbour(row: row-1, column: column, regionNumber: regionNumber)
                }
            }
            //right
            if column < knotHashes[row].count-1 {
                if knotHashes[row][column+1] == "#"{
                    findAndMarkNeighbour(row: row, column: column+1, regionNumber: regionNumber)
                }
            }
            //left
            if column > 0 {
                if knotHashes[row][column-1] == "#"{
                    findAndMarkNeighbour(row: row, column: column-1, regionNumber: regionNumber)
                }
            }
            //down
            if row < knotHashes.count - 1 {
                if knotHashes[row+1][column] == "#"{
                    findAndMarkNeighbour(row: row+1, column: column, regionNumber: regionNumber)
                }
            }
        }
        
   
        for index in 0...127 {
        let startString = "uugsqrei-"
            let knotHash = getKnotHash(withString: startString + String(index))
        var binaryKnotHash = ""
       //
        
        for CharacterInKnotHash in knotHash {
        
        var binaryValue = String(Int(String(CharacterInKnotHash), radix: 16)!, radix: 2)
        
        while binaryValue.count < 4 {
            binaryValue = "0"+binaryValue
        }
            binaryKnotHash += binaryValue
        }
        
            
            for BinaryKnotHashChar in binaryKnotHash {
                if BinaryKnotHashChar == "1" {
                    antalEttor += 1
                    BinaryKnotHashRow.append("#")
                } else {
                    BinaryKnotHashRow.append(".")
                }
            }
            
        knotHashes.append(BinaryKnotHashRow)
            BinaryKnotHashRow.removeAll()
          
        }
       // print(knotHashes)
        print("number of hashtags: \(antalEttor)")
        
        // Test for regions
        
        var noRegion = 0
        
        for indexRow in 0...knotHashes.count-1 {
            for indexColumn in 0...knotHashes[indexRow].count-1 {
                //FindNeighbours
                if knotHashes[indexRow][indexColumn] == "#" {
                    
                    findAndMarkNeighbour(row: indexRow, column: indexColumn, regionNumber: noRegion)
                    noRegion += 1
                    
                } // end find neighb..
                
                
            }
        }
        
       // print(knotHashes)
        print("Number of regions: \(noRegion)")
    }
    
    
    @IBAction func btn13Dec(_ sender: Any) {
        
        var emptyNode: [String] = ["S"]
        
        func getEmptyArray(withDepth:Int)-> [String]{
            
            var myArray = Array(repeatElement("", count: withDepth))
            myArray[0] = "S"
            // print(myArray)
            return myArray
        }
        
        
        
        
        // Import data
        // import PlaygroundSupport // Gör så att man kan spara alla filer man behöver i ett och samma bibliotek
        
        let fileURL = Bundle.main.url(forResource:"13dec", withExtension: "txt")
        
        // print("\(String(describing: fileURL))")
        var fileData:String?
        
        do {
            fileData = try String(contentsOf: fileURL!)
            // print(fileData!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        let indata = colonSeparated(data: fileData!)
        
        // MakeFirewall
        
        var fireWallMall = [[String]]()
        var fireWall = [[[String]]]()
        var sumSeverity = 0
        var notCaught = true
        
        
        for nisseIndex in 0...indata.count-1 {
            
            let tempDepth = (indata[nisseIndex][1])
            fireWallMall.append(getEmptyArray(withDepth:Int(tempDepth)!))
            
            //Padding with empty  when having gaps
            if nisseIndex < indata.count - 1{
                if (Int(indata[nisseIndex+1][0])!) - nisseIndex > 1 {
                    for _ in 2...Int(indata[nisseIndex+1][0])! - Int(indata[nisseIndex][0])! {
                        fireWallMall.append(emptyNode)
                        //   print(emptyNode)
                    }        }}}
        
        // end MakeFireWall ---------------
        
        //print(fireWall.count)
        // Skapa styrarray som har koll på riktning S
        
        
        let styrArrayMall = Array(repeatElement(1, count: fireWallMall.count))
        var styrArray = styrArrayMall
        fireWall.append(fireWallMall)
        let startValueTest = 2500000 // här börjar den skapa firewall
        for indexMakeFireWall in 0...2500000 + startValueTest{
            for indexOverFireWall in 0...fireWallMall.count-1{
                
                if fireWallMall[indexOverFireWall].count > 1 {
                    //print(fireWall[i])
                    let startS = fireWallMall[indexOverFireWall].index(of: "S")!
                    
                    if fireWallMall[indexOverFireWall].index(of: "S") == fireWallMall[indexOverFireWall].count - 1 {
                        styrArray[indexOverFireWall] = -1
                    } else if fireWallMall[indexOverFireWall].index(of: "S") == 0 {
                        styrArray[indexOverFireWall] = 1
                    }
                    
                    fireWallMall[indexOverFireWall][startS] = ""
                    fireWallMall[indexOverFireWall][startS + styrArray[indexOverFireWall]] = "S"
                }
                
            }
            if indexMakeFireWall > startValueTest{
                fireWall.append(fireWallMall)
            }
        }
        
        
        var timeDelay = 0
        // move S and () = timestep
        repeat{
            
            sumSeverity = 0
            notCaught = true
            
            for timeStep in timeDelay...fireWall[0].count-1 + timeDelay {
                
                
                if notCaught{
                    
                    
                    if fireWall[timeStep][timeStep-timeDelay].count > 1 {
                        // print("paket på 0:\(timeSteps-timeDelay)")
                        
                        if fireWall[timeStep][timeStep-timeDelay][0] == "S" {
                            notCaught = false
                            sumSeverity += fireWall[timeStep].count * (timeStep-timeDelay)
                        }}
                    //Uppdatera brandvägg flytta S i alla
                    
                    // print(fireWall)
                    
                }
            }
            
            print(" last post is Answer:\(timeDelay+startValueTest + 1)")
            timeDelay += 1
            styrArray = styrArrayMall
            
            
            
        } while !notCaught && timeDelay < 2500000
        
        
        

        
    }
    
    @IBAction func btn12dec(_ sender: Any) {
        
        
        let fileURL = Bundle.main.url(forResource:"12dec", withExtension: "txt")
        
        // print("\(String(describing: fileURL))")
        var fileData:String?
        
        do {
            fileData = try String(contentsOf: fileURL!)
            // print(fileData!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        let indata = spaceSeparated(data: fileData!)
        var unikaSets = [Set<String>]()
        var set = Set<String>()
        var sets = [Set<String>]()
        
        for index in 0...indata.count-1{
            //print(indata[index])
            set.insert(indata[index][0])
            for indexSets in 2...indata[index].count-1{
                set.insert(indata[index][indexSets])
            }
            sets.append(set)
            set.removeAll()
        }
        
        //print(sets)
        
        var conectedToNoll = Set<String>()
        var firstSet = true
        var counter = 0   //Counter to se how long we have come
        let noSets = sets.count // Number of sets
        
       
        for set in sets {
            print("\(counter) of \(noSets)")
            counter += 1
            
            conectedToNoll = conectedToNoll.union(set)
            
            var antalItems = conectedToNoll.count
            
            repeat {
                antalItems = conectedToNoll.count
                for indexUnion in 0...sets.count-1{
                    
                    if !conectedToNoll.isDisjoint(with:sets[indexUnion]){
                        conectedToNoll = conectedToNoll.union(sets[indexUnion])
                    }
                    
                }
            } while antalItems < conectedToNoll.count
            //print(conectedToNoll.sorted())
            if firstSet{
                print("Programs connected to program 0:\(conectedToNoll.count)")
                firstSet = false
            }
            var isUnik = true
            for unikSet in unikaSets{
                if unikSet == conectedToNoll{
                    isUnik = false
                }
                
            }
            if isUnik {
                unikaSets.append(conectedToNoll)
            }
            conectedToNoll.removeAll()
        }
        
        print("Unika sets: \(unikaSets.count)")
        

        
    }
    @IBAction func btn11dec(_ sender: Any) {
        
        let fileURL = Bundle.main.url(forResource:"dec11", withExtension: "txt")
        
        // print("\(String(describing: fileURL))")
        var fileData:String?
        
        do {
            fileData = try String(contentsOf: fileURL!)
            // print(fileData!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        // Här börjar programmet typ Main()
        
        var numberOfSteps = 0
        
        var indata = [String]()
        
        
        
        var directionCases = [String]()
        directionCases = ["n","ne","se","s","sw","nw"]
        
        
        // Lite test-indata
        // indata = ["se","sw","se","sw","sw"] //[String]()
        //indata = ["se","sw","se","sw","sw"]
        //indata = ["ne","ne","s","s"]
        
        indata = csvArray(data: fileData!) //<------------- HÄR ÄR INDATA
        
        // Hjälpfunction för att ha koll på riktningsvärden
        
        func directionValue(direction:String)->(deltaX:Int,deltaY:Int){
            var deltaX:Int = 0
            var deltaY:Int = 0
            
            switch direction {
            case "n":
                deltaX += 0
                deltaY += 2
            case "ne":
                deltaX += 1
                deltaY += 1
            case "se":
                deltaX += 1
                deltaY += -1
            case "s":
                deltaX += 0
                deltaY += -2
            case "sw":
                deltaX += -1
                deltaY += -1
            case "nw":
                deltaX += -1
                deltaY += 1
            default:
                print("oops")
            }
            return (deltaX, deltaY)
        }
        
        func getMove(directions:[String])->(deltaX:Int,deltaY:Int, antalMaxSteg: Int, antalStegToFind:Int){
            var deltaXSum = 0
            var deltaYSum = 0
            var antalMaxSteg = 0
            var antalSteg = 0 // antal steg till "hem"
            
            //print(directions)
            for direction in directions{
                deltaXSum += directionValue(direction: direction).deltaX
                deltaYSum += directionValue(direction: direction).deltaY
                // Ta reda på maxSteg efter varje direction
                if deltaXSum >= deltaYSum{
                    antalSteg = deltaXSum
                } else {
                    antalSteg = deltaXSum + (deltaYSum-deltaXSum)/2
                }
                
                // Är den störst?
                
                if antalSteg > antalMaxSteg {
                    antalMaxSteg = antalSteg
                }
                
            }
            return (deltaXSum, deltaYSum, antalMaxSteg, antalSteg)
        }
        
        
        
        
        print(getMove(directions: indata))
        
        
    }
    @IBAction func btn10dec(_ sender: Any) {
        
      
        
        // SETUPP
        let indataLengthString = "63,144,180,149,1,255,167,84,125,65,188,0,2,254,229,24"
       
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
                
                print("current: \(currentPosition)")
            }
            
        }
        
        print(circleOfTrust)
        let sparseHash = circleOfTrust
        
        var denseHash = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        
        for indexBlock in 0...15{
            for indexInBlock in 0...15{
                denseHash[indexBlock] = denseHash[indexBlock]^sparseHash[indexBlock*16+indexInBlock]
            }
        }
        print(denseHash)
        
        var knotHash = ""
        for indexInDenseHash in 0...denseHash.count - 1{
            
            var häxan = String(denseHash[indexInDenseHash], radix: 16)
            
            if häxan.count < 2{
                häxan = "0" + häxan
            }
            
            knotHash = knotHash + häxan
            
        }
        
        print(knotHash)
    }

    
    @IBAction func decsteg1(_ sender: Any) {
        
        /*
         
         tecken som ska hanteras
         
         {}
         <>
         !
         ,
         
         
         */
        let fileURL = Bundle.main.url(forResource:"/9dec", withExtension: "txt")
        
        // print("\(String(describing: fileURL))")
        var fileData:String?
        
        do {
            fileData = try String(contentsOf: fileURL!)
            print(fileData!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        let indata = "{{{{{<!!!>},<!e!!!xue!o!!!>xoo<u!}<<{>},{{{}},{<!>},<x>,{<!!x!!!>xu!!!>!!!>,<x!>,<!>},<}!!}!!!>{>}},{{<x!>}}!x!!u!!!!e!!!>>}}}},{{{<!>>}},{{{<{{!!,>},{<u!!ex!>},<>}}},{<,o!!!xxa!>},<!>},<<}>,{<!!!!,,!>,<!>},<x!!!>u>}}},{{{<}{!<{i!>>}},{{}},{{},<!>,<!>,<!>!!,<!!!!{}!!i>}}},{{},{{{}}},{{<ae{>,{}}},{{<!!!!x>,<{x}!!},<!>a,!>!!!>{!!e>},{{<!ao!!i!x!>,<!!o>,<xe}!!!>!!!>ex!!u{>},<x,xi!!!>{>},{<uai,!!{!>},<uu!!e>}}},{{{{{<!!,a!>>}}}},{},{{{{{{},{{<au<,!!iuu!!!!!>,<>}}},{<i!>,<!>},<!!xiu{!!ox{i,i}!{{>}},{},{{<a!>ax!!!!!>},<>,{<!!!>x>}},{{{{<ae}a!!!!{!},u!!o<!!!x>},{<!>,<!!!>!!!>},<ee<!x!>},<!!!>uxae>},{<ex!!!>},<xe!>>}},{<u!>},<a!>!>i,u>,{<i,!!>}},{<x>}},{{<!ee!>},<!!!>!!!>>},<!!!>},<a!u>}}}},{{{{{}}},<!!!>>},{}}},{{{{<!>,<,,},,!>,<<!!!!<<!!<!!!!>}}},{{},{}},{{},{<o,!>},<!!}!,!>},<o!>uoa{<a!!,<a!>,<>}}},{{<x!>},<e!>>}},{{{<!>x<e!!!>}!!!>!>u<xi!!}x!!!>>},<ie!>a{!{>}}}},{{{{<{i<!>}e!>},<}!!,,!>},<!!aa!>a!!!>!,{>,{{<ii!>,<>},<{e!!!>x!!o!>,<xa!>},<u!>!>>}},{<!!!>x!>,<!<!>,<u!!!!i!>,<a!eeu!!!!!>!!e>}},{<i,}a!!{e>}},{{{<}eue!a}{x{xx<!,!>x!>},<x>},{}},{{}},{{},{{{}},{<x!!,iexe!!!!!>x>}}}}},{{{<!!<<!!!>o!!!>eie<!!!>e!>x!!!!!!ie>,<!>!>!,!!u!!o!!!>!!!>,<xx!!u!!}u}<}!>,<}>},{<!,!>},<auo!!!>!>,<{}!>,<!>,<>},{<>,<<!>},<{>}},{{{<a!>},<i!!!!!>!!e!>u>,<!>!>},<!>},<a!>!!!!!!i<ae{<!>,<!><o!!!>!io>},{{{}}}},{{<{,ii!!!>!>,<ix{uo!!!>{a!e>},{}}}}},{{{{{<!>,<u!>!!!!ax,!!,!><!!!!!>,!>,<ix>},{<x!>,<!!x>}},{{},{{<!!!>!!!>>},<>},{{{},{}},<e{!!!>!!!><u!>},<iioi!>,<!>!>},<o!!!>!<!x!>>}},{<<<!a{!e}!!x!!<!>},<!>,<xeoiua}x>,<!!<!!>}},{{<!>>,{{<!!!!!>}!>!!a<!!u!!!<ux!!!>>},{{{<!!!>xi!!ae<!><i!>,x>}}}}},{<!>!>i!>,<}!>!u<!!!!!>!<xo!>u!!!>!>e>,{}},{{{{<!!ax!>},<!><{u,}xx!o!>},<!>,<>}},<!!!>,<!o!>,<!>,eea,!!!>i,,ue,ie>},{}}},{{<xex,!!!>!>,<!!x!!!>x!>{i!,!!!>},<xx!>>,<!!,!>},<}uu!>xax}!!<!>},<!>,<!>}o!!oxx>}}},{{{{},{<!!,!!a>}},{},{{{{<xuo!!!>!>,<x!>e,<x,aux}>,{}},<u!>},<!><a}xei!>x!!}a!!!>,<!>u<u>},{}},{},{{<}x!!e!>,<{!!!>!!,!ex!>},<!>},<!!!>,<!xe>},{{<!,iuee{u!!!>i!!!>{<!!!>},<!i!>},<!!>}}}}},{},{{{{{{<!!u!>},<o>},{<!!!o!!,>}},{{{},{<i,x<a!!x}!>>}},{<}axu!!xx!!<!>,<!x!!xxuai!!!>},<>},{<>,<}!>!>o}}!!o{!>},<>}}},{<!>},<!!!x!!!>a!!!>!>},<!>}!>,<>,{<{!!e!>,<x!!u!!!>x!!!>!a!!a<oox!!!>!>i>}},{{{<!}!>},<}u!!!>!!!>!>},<!>},<>}}}},{{<}!>,<a,xo<!>!!!!!!x<!!exax}!>},<>},<!!!ee,x<}e!<!>,<ix!!!!!>u!!!>,>},{{{}}}},{{{<,>}}},{{<o,!!!>!>,<>}}}},{{{{<u!!!>>},{{<xi!!!!!>,<!!a!>,<}e<!>,<x>},{}},{<{<!ax>}},{{{},<e!>,<<e!oou!!!!!!x!!i!!!!xa!>},<,!>,<<>},{}},{{<!>,<!!e!>!>},<o<!>!!!!!!ox{!>},<>},<,i{i!>,<oaue<xex!!u{ue>}},{{<e>},{{},{{{{<e{oi!>,<o!!!!u>}}},<e<!ue!!oo{!>,<a{!u<!>,<x}i!!x>}}},{{{<!>},<!!o!!e!e>,{<}!!{{!>,<!o!!ao}{{!>,<>}}},{{<ox>},<,u!!o!!u>},{{<>},<x!>,<i!!!>},e!,e!!{>}}},{{{{<xao>,{<!>!!xx!>!u!>,<i!>a!,{u!!i!!!!!>>}},{{{{<!>},<axxoi!>xx>}},<a<e{,,o!!x!!!><>}}},{{{{<au<!!!!!>!>,<>}},{}}},{{{{<oa!!!>iaui!,!!}>},<ia!>},<uxu!!!>!>u>},{<xu{xxu!,!!!>>}},{<!o,{!>a!oxx!u!>,<!!!>},<!!o!!!!!>,<>,<}<,!!o!>},<}{}{!>},<{x>},{{<!!}}!>,<!>!{e<x!!,!>,<x>,{<x!<!!u!>},<!!!!!i!!u,xoo!!!>!!!>xa}x>}},<!!xu!>},<au!>},<!!!>!>,<>}}},{{{{<a!>,<x!>,<>},<!>,<<o!<!!!>,<!!i!>!xi!>},<}>},{{{<o}!>>,{<!>>}},{<!!!!!>!!<e!!<e<,!{!>,<>}},{<!!!!eoxx!>,<}<}!o<!!!>{u>,{}}}},{{{}},{<x!>!ai!><xe!x!>!>>,{<u!>,!>!!ae!!xe!!!>e>}},{{<!}!!uxe{i!!x!x!!x<!!!>,<>},<oxa,xe!>,<{{aau!<{u>}},{{{{{},{<e!!xi!>!!!>u!!xxxo{!>},<!!o>,{<}!!>}}},{{<x}o,iex>}},{<!!x{!>},<ue!>,<!!!>!!ia!>,<x>,<a,<ouuxa>}},{{{{<u!>,<!>},<e!><!!!!}}!>,<!>},<}a!>},<i!!x!i!!!>a>},<!xu!!ixioe!!!>!!,!!ie,!>ox!>,<!>,<!<>},{{},{<o!>},<{a!!!>x{>}},{{<iu{}x!>,<x{!>i<o,e!>,!<>,<<!aa>}}},{{},{<i}!!!>>}},{{<a!i,,!e<!>},<!xix}x!>{ii!!!>!!,>},{<u,x!e!!!!x!ee!!x!!i!!!>},<}>}}},{{<!!!>!!u!>,<u!>xo<<}!>uu!!u{!!u!x!!!>>},{{<!x!>o>},<i{ioeu!>},<{au!!!>!>},<i!>},<!>,<!>},<!!!!,e>}}},{{<!!!>},<!!!>i<o!!}}e!,i!>o!!!!i>}}}},{{{{{{<!>},<>,<xe!a!!!o}}<x!!!>,x}!>a!!!>xe>},{{<e!>!!{x},,!>,<!!x!!!>aa>},{}},{<!!,,!e!>!>},<!>,<x{x!!!!!!!!!>>,{<x!!!i!>},<o{xx}x,,!{ou!!>}}},{{},{{<!!!!!x!>{oe<{!!<!!!!!!x>},{<!>,<<xe!x!>!>},<!>},<{!!o!>,<e!>!!u}!!e!!>}},{{<}ox!>},<!>},<!>!!<!u!!!>},<!>},<i!a>}}},{{{{<x!,!!!!ii>,<<!{!!!>!!!!!>!>},<!!!>!!x!>,<o{iuo!><!!o}!!!!!!!!!>!!!>>},<!>!>,<!>ao!!!!!>!>},<<!!{xe!!,!!{x!!!><>}},{{{<!!!>,a!>},<!!!>>},<!!!>!!>},{<!!!!<!>,<,>},{{<}!}!>,<o!!!!!!!!!>!!!>x!!a!>},<>}}},{<>}}},{{{{{<!>,<!>,<!!!>},<i!>x!>},<o<!!!>a!!!>!!!>!>!!,u!>>},{<<xx!!,!>},<x{<!o>}}}}},{{{{<}!>,<o!>,!>},<!!!>xix,!>},<!!!>,<{!>,<o!>,<!>},<>,{<<!>!>,<!!!>!>},<>,<!!!!a!!a}{{!!!>x!>,<{<<!>,<>}},{{<!!,>},{<!>,<!!ao!!!>!>!!!>!>},<,i{o!!!>x!!e!>,<!!u>}}},{{},{{},<u!>,<!!!>!!>},{}},{{{{<}xe,}>},<>},{{<e!i{!!!>!>},<x!>},<!e!>,<{>}},{{<>,<{{!eix!>},<<{!>,<a!>!!x>}}},{{<!>,<{!!{}i!>,<{!>x<!>,<!>!!!>!!!!!>!ou>,{{{{}}}}},{<{x!x<}}>,<a>},{<{{a>}},{{{<>,<!!ux!>},<!>u!!!>x>},{{{<a!>},<o!>},<x!!!>o!>,<!>,<{u!!{!x{!!!!!>>},{<,<!>{!a>}},{{<}>},{<!eu<!>,ux!>},<!!!><e{e!!!{<!!!>!!!>>}}}},{{{},{<a!>,<<e!>},<!!!a<u!!!>},<!>,<i!>,<>}},{{{},{}},{<!!,!!!>},<ia!!!!!>,<!a!!!>},<ix!>,<!!!>!>},<>}},{<xa,!>,<!!!>!!!>,<x!>,<<xu>}},{{<!!!>xu!!!><x!!!>{>},{<x!>,<}>}},{{<i!!{!!!>!!!!i,!>!!<u,u!>},<x!>},<ao,x!!>,{<e!!<xe}<!o!>{!>!>!!!!xi>}}}},{{<!>},<!>},<}!!!>x!!<!!!!!>e>,<!>ia!>,<!>x!>!!!>i!!!!!!u!euxa!!,!>},<>},{<{o!>,<<x{!!!>!!o!>},<!xa!>>,{<<e,!}ao!>ui<!>!>},<xe<!!!!{a!>!>,<>}},{<>,<x,!>iaoi!u<oex!>>}}},{{<!>exe!!!>},<,u!!e!>,<!>,i!!oi<>}}},{{{},<!!u!>!!!>i!!!!e!!,xu>},{}},{{{},{{},{<!>},<!a>}},{{<xo!>},<!>},<!!!>,<!,>},{}}}},{{{<!>!ei!!{!!<!!>},{}},{{},{<io{!>},<!!}!>},<!}a!>u<>}}}},{{{<!>!!!>x!>!!ua>},{{<!!!!!>{!x>,{<!!x<xx!!!>}!!!!!>!!a!!x!ox,!!!!!>!!>}},{{<!!x!!!>{{,!>,<!!!>!!i!!ea!!!>!!!>x>,{<!a<!>},<!>,<eoe!x!>e<a!!}xe!>},<o!!>}}}}},{},{}}},{{{{{<!>!{!>i}!xx!!!>iau!>},<o>}},{},{}},{{{}}}}},{{{},{<!>,<!!u!>},<!!!!<<!>,<!>auo!>x>}},{{{}}}}}},{{{{{{<!>!>},<!!!>oe!!!!x!>},<x!!!>>},<!>{!!xx!>,<!>},<oexx{x!>,<>},{}}},{<u!e}!>,<!<!<!<x!o!!x!!>,{{}}},{{<uia!!ee!>},<!>e>}}},{{<o!xxe>,<!!!>eu{x!!}a>}},{{{{<!!!!!>!>},<!><o!i>}},{{{<!!!>,<io!>,<o}ou!>,<!{!>},<!!ou!>!!!>!>,<!!>},<!!<x!!!>,u,!>o}x!a>}},{<!>x!!{eox!>},<!>!>,<e!!a!!!>!!!>{,,!!!x>,{<xioau}x!!!!!!!>!!!>ix>}}},{{{<{!!uo{i!>},<,}>}},<ie<{u<!>},<!!xi<>}}}}},{{{{{<!!!>!!i>},<>},{{{<!>},<{!!,!!axxi!!}{>}}},{{{<!>},<!>,<a!!!>,}!!!uxe!!!o>},{<!!x{!!!>,<!!x!>},<!!!>e,!>,<ex!!!>oo>,{}},{<}}!>},<ox!!!>!!!>!>},<ee!!x<!,>}},{{<!!!>u{!!e>},{{<!o!>},<ex}u!x!!}a!!a{<,!!ee!>}>},{{{{},{<!{u{!x,u!!!,>}},{<xx!!!>!aexa!!!!o!!!>a!}!>,<>}}}},{{<!!!>oxi!!!>x!!!!!!!>!!!!!>},<}!!>},{}}},{{<x!>,x!!!>},<oo!ox!>},<o>,<>},{<auu{<!>e!>},<!!!>}x>},{{<}xu!!!>!!,xi!>e>},<x,u>}}}},{{{{<!>,<{x!!a!>,<xou!!,a!!!>},<!!!!{>}},{{{{<!!!>,<o!>!!!!eue{!>},<!!u<>,{<>}}},{<!!<{!!!>oo!!u!>,<!!!>!!!>,<!<>}},<xeo<!!!>x!,!!!>>},{{}}},{{{<>}},{<a,!>!!!>!>},<<!>},<}o!!!>uui,x!!xi}>},{{<!!!>!!<{<!>eu!>,<a!!>,{{{<ixeua!!!>!!!u!!!!!>!o!>,<!ixe>},{<iox}x!>,<a!<!>!x}ox!!!<!!>}},{<{e!!!>!!!},!>,<xx>}}}}},{{{}}}}},{{{{<}!!!>eo!!!>a!ex>,{<ui!!!!!!!!a!!!>!x>}},{{<u}x!!ixueo!>>},{<u>,{<o!>},<i!!{!!!>}!!<xu!!!>},<>}}}}},{{{<>}},{<!!!!!>!!{<aoo!>},<!!xou>},{{},{<!>},<}!>,<u,x!!!>e}!>u!{o{!>,<!!ae>,{{<!>},<o!>,<!!o>},{}}}}},{{{{}},{{<o,{!!!>!>!!{!>},<,>,{<}e,!!!>>}},{}},{{{<{!>,<!!!!ai>},<!>,<i>},{<!!!>!>,<!!,!i!>!>,<xx!>!x!>!!i,>}}},{{{{{<a!>,<u{{!!!o!!{ua!>,<!!x!}x!!!}!!!!x,au>,{{<!!{{!!!>>}}},{{{{<i<o!!i>},<ia!!!e!!!!!><!>,<i!!!>}!>,<ii<!!!!!>>},{{{<,!!!>,<!!<>}},{{{{<!!!!!>},<!!i!>,<!!e!>,<!!!i{<!>!!!!!>!!!><e>}},{}},{<!!e!uuix<{!>,<>}}},{{<!>,<!!!>{,aa!!u!!o!!{u>,{{{<{!!!>>}},<!>>}},{<,!>},<!>,!}x!>}!>},<xi!!!>>}}},{{<!!!>u!>},<i!>,<!>},<!!!!x!!!!xee!!!!!>!>},<o!<!>},<e>,<e!!!>x!>!!e!>,<x,!!>}}},{<a!!}o!!!{{oxe!u!>,<a>}},{{<}!>},<}e}!!!>!uax>},<!>ooe,ux!!!x>}},{}},{{{<o{,x!!!>oxxx>,{<!!xe!>,<oi,!,>}},{<x!!!>,!<<a!>>}}},{{{<,o!>,<!>},<!!!!!>,<}a,!>}!>},<iei!>,<!!>}},{<{{,!>,<>,{{}}}},{{{{{{<!>},<e,<!!u!>},<a!!!>xx!!!,xo!{>}}},{<!!a!>,<{!!!!xx!!!!!>x!!oa{{!>,<!>},<>,{<x,!!!>!!a!!!>},<e!!!>!!xii<a!>,<!x!!>,{{<x!!!!!>!>},<e},>},<!!<a!>,<x!!!>ax!!!!<x>}}}},{<i!x!>!!!>},<,uxu!>},<i!!i!!!>,<<,!!!>oai>,{}},{{<u>},<!<ea,>}},{{},<{!x<!a!!!>!>,!>{!!!!!>u!!x>}}},{{{<>},{<!!!>x{o!!!>!!!>},<!!!,>}},{{{{{{<{!!a{<<a!!!>!!!>!!!>,<!!!>!!!>>,<}xe,!oaexx!>,<!!{u!>},<!!}!>},<x>},<}!>,<<{a!!uo!>!>,<!>,<!!ei!>},<{>}},{{{<,xi!>,<i!>!!!>o!oa!>,<!x!auxiau>},<!>,<uiu!!!!!>}aox{u!!!>x!!!>a>},{<!o!>,<,i!>,<!>},<u!!a!!!>},<}!!!>u!>},<!!<o>,<!!ei!>},<!!!>!!!>},<{x!!!>,<<!!!>u!>!!!>!>},<a>},{{<{!>x!!<x!!!!>}}},{{<>},{{<!!!>e!>,<!!<o!!xo{,x<!>},<!>}>},<!!}!!>},{<x!!a!>},<!!ioiauxu,!!!!!!,!>},<i!!!>{>}}},{},{<!>},<!ox>,<!!!>}!!!!!>!>},<x!>},<!>,<>}},{{{{}},{{{{}},{<i!!<,!!o>}},{{},{<!>},<!!!{u{!!!>a!!!!i!!,x!>},<}>,<xx!>x>},{<i>}}},{{<!!!>!xa!>,e<i!!!>,<,!!!>!>>}}},{{<!>,<!x{!>x!>,<<o<ue{{}}!>,<!!>,{<u}>}},{}},{}},{}}},{{<!<!>{xau!!x{!>,<>,<!{>},{{{<e!>u!{x!o{x!!!>!!x!}!ex!>},<oiua>}},<,!>,<!ex>},{{{},{<!!a!>}!!!>ux!a<!>,<,x{!>},<a<!>,>}}}}},{{{<!!,!x}!>}!!}!>,<!}xx!!e,}!>},<>,{<,!>},<a,<u!!!>!!}}ex!}>}},{{{<a>,{<<e!!!!uxauo!>u!>,<>}}},{{<!x<!!!>{u!>,<e,{{!!!!x!>,<!>,<,}!xxxe>},<<!>},<oua!!u,<<>}}},{{{<eux!>uxuu<>}},{},{{},{<!!!>!!!!u}iio!>>,{{<oo!!!>{!>,<{!!!!!>,<i,!!}}!>u!>a!>,<!{x>},<!>},<a!!!>!}!,ea>}}}},{{{{<!!i!>,<!!!><u!!a!!!>,<>,{<!>!>}!!o!!!><a<>}},{<!>,<!!x{i!!a!ax<!}!!ex!!!!a!>x!!!><>},{<!!!>},<!!!>,<!uea!>},<x!!>}},{<!>,u{<!>},{!{iie{!>},<<o!>,<>,{{<!!!>!!}iux!!!>e}!!!!o!><!>!!!>,<<!>,<!!!>,<!!,>}}},{{<xix{!i!>a!!{!>,<oaa!a!>},<>},{<!>,<ox>}}},{<!!}!!e<e>,{}}},{{{},{<x>}},{<!!!!x!!o!!!>x!!!>ix>},{{{{}}},{}}}}},{{{{<ix<u!{e{i>}}},{{},{{<o>,{<!!<}}{{o!!a}!!!{ao>}},{{},{{},<uux!},!!e!ouu<oia!!!>e}{e>}},{{{<<,exa!!!>},!!!!!>e>}},{{{<o!>},<uo!!!>!>!>,<u,!a!!!>!!!!!>}!>,<!!!>>},<!a}i,x>}},{<!>,<!!,!>}!!<}!!!!!>ae<u!>,<!>,<!!!>!{<!!!!x>}}},{{{{<!!,,!>},<i}<{>,<!>,<!!{}o!!{,<,,!u!x!>,<>},{<}!!!>>,<oo<!>},<<ou}!!!>}e!>,<!>,<>}},{{{},{}},{},{<uou>}},{{{<!>!xx<ea>},{<<i!>},<xaau!>},<!>,<}ix!>!!>}},{{<ex!>,<{x!!!!!!!!!>,<<euix!!},!!>}},{{<xi!!<>,<!!!!x!>,{<!>!!{!!!!!!a{!>},<>}}},{{{},{{{{<!>!>},<>},{{}}},{{{<xx!!!>ai!!a!>!>,<>}}}}},{{<a!>,<!!xa}<,!!!>},<,!!,!}!>},<>,<!!!>,<{!!!>!!io!e!>,<!!!!!>,>},<!{i!!!>,}x{o!!,<!>},<!>!>!>},<oie>}}}},{{{{<,,!!i!>,<!>o!>,<>},<}!!!>},<e!>,<}!!>},{{{<!!!{oo!>,<!!!>!!!>,<o!!!>e>}},{<!!{,!>!!!>!!<!>},<!!!>!>,<ix!!!>!!!>},<x!>,<>}},{<a!>,<!!!!i!axo!!!>u!!!>i>,{<xu!!}oe<!>!e!!x>}}},{<i{!!ox>,<!uox}!!!>!!!!!!ou<!!!!!>}a>},{{<!!!!x{}>},{<uoeua!>},<o!!!>!,ix>}}},{{{<!!!eo{>}}},{{<!!{!!xui!!!>!>},<>},{<ax!!!<o>}}}},{{<,ux!{!!x!>!!!>}>},{{},{<,!!!!!>},<e!!x>}}}}},{{{{{<!>,<!!,>}}},{{<!!ouaox!!i<>,<!x!>,<!!oe!>,<i}ei!x{!u!>},<,>},{{{}},{<<!>,<>},{{<<<,u!!x,!xx!!!!!!<a{u!><!u}>,{}}}},{}}},{{{{<!!!>o,!!!!<uu!}!!exuu!!xe!>!e!>,<!!>}},{{<>,{<u!!!>,<,!i!!!>xxu!}}!!!>!<ex!!!!<!!>}},{<u!>},<}{!!!>,<o>}}},{{},{{<!!!!!!ux!>},<,!>,<!!a!!,iu>,{<!{!!!!}>,{<ei!>,<}oo>}}},{<!>!>,<!uo>,<>}},{<o{x<xi}{!{{eae>,{{{<!!!e>}}}}},{{<}u!a}!!!,!,xe>},{{<>},{{<x!>,<aox}!>,<!!!>,!>xeu{i!!}!>},<,>},<!{!>},<!!!!{{!!!!!>!>x!!<!!!!>}},{{{<u!>,<u!!!>u!!xi>}},<!!!>ii!!!>}{!><{!>ex!!!!!}{}!>!io!>>}},{{{<>},{<ua!a!>!>!!<!!!>!!!>,{u>}},{{<>},{}},{{<!>!>,<au{u!>,<>},{}}}},{{{{<,!!!>i!>},<x!!!<!!!>u!!!>i<!}!>},<!!!!e>}},{{<ux!>i!x>},{{{{},{{}}},{<!!!>!!}!>,<o<!!!>},<<e<i<x}xx!>,<!>,<x>,{<xxi!!ae{o}!>!,a>}}},{<!!!><!uu<!!{!>,<}}x!o!><{>,{<!u{!u!>!>},<xaxa,!>},<!!}{!!,xei>,{{}}}}},{<{i!!u!>},<!>},<!>!oo>,{<e{u}<,!!!!!!ixo{<!!!>!!xixuo>}}},{}}}},{{{{{{{{<u,<!!<i}a!>!>,<e<!>},<,i!o!>,<>},<u!!!>,oii,!>},<}}!}<e>},{},{<i!>!!i!>e!>},<!>!>},<>,{<!!!>ii}<!!!!!!e{!!!>x,!!!e!>,<u<>}}},{<>},{{<a}!!}i!>,<io<i!>},<{!,ex!!!>,<!!!!!!!>!!iu>,<!!!>o!!u,!>!>,<!>,<xi!!e!<ex>},{<!!,{{!!!>x>}}},{{{{},{<!!!>!!!>x,oao}<!{!!{!o>}},<!><!>,<e!>,<o!!!!ou!!!!!>},<!!!>>},{{}},{{<!>!!!>x!>!!i!!!>!!!><!!!><!!!>i!<!!!!<{!!!!!!!>e>,{<,,>,{}}}}},{{{{<u,!>{uu>},{<>}},{},{{},{{<xe!!i<!!!>,<xo!!!>,<}u>}},{{<>},{<!><>}}}},{{<!!i<!!>},{{<!>,<!>},<!!!>!!,e{>},<eux!!}u}!>},<<a>},{{}}},{{{<!i!!au!>},<,!!!>},<ux<,{{!!,!!>},<a{!!!>>},{{{<e!!!>a!>,<}e!!!>{>}},<!<!!oa}!!xx!>},<xu>},{{<,ua!!aoo}!!{!!!!!>!!xeau}}!><!!!>>},{<!!!!!!>}}}},{{<!!x>}}},{{{}},{<,!u!>!>,<!>,<xx!!!>!>},<xax!!aou!!!><>,<u>}},{{{<i!>,<!!i!!!<aa!!a>},{<!>,<a!>},<!!!><!>,<a!>},<!!u!>!!!>xx!>,<!!}>}},{}},{{<o!!o>},{{{<{!i!!!!e<ua>},<>}},{<!!!>!!!>x!!x,e}u!>},<!!x!>,<!>,<>,{<xe!}!!<!>,<i!>,<xo!>>}}}},{{{<ux!>},<{!!xu>},<!>,<<!!!>!!x!>!!!>,<ux<}x!>,<eex!>,<a>},{<!!i>,<o!>,<!iu!>},<!!xo<}!>,<,x>},{<<{!>},<<!!!>}x!!!!!!!>!!x!xo!,!!u>}},{{{<!!oixax!>x!u}!>,<u!>},<xu!>!!x>},{}},{{<!>},<eae!}!!!>aa!>oa!!o!!!>!!}<u}>,{}},{{},{<!!!ae}<!!,!!!!{!,u!!<!!,!!!!!>!>},<>,{<xx!>!!!,u!!oo!>,<>}}},{{{<!>},<!>!>},<}!!!>a<x{a!!!>!!<!>,<!{!!!!!>>},<{>},{{<!x!>,<x!!!>>}}}},{{<}<i!>eu}u!>},<iii!!}o>},<aaxu>}},{{{{{<<!!x!>},<!!!!<!>,<x,{ox{x!!i>},{<!!!!!!<e!ix},!}uua<>}},{<i!!ax{>},{{{<{!e<!}!!!>,<xo{>},<o!!!!!>{!>},<!!!>e!x{!>},<{!!xu!>},<ioia>},{<!!!!u!{<!>},<x>}}},{{<!>},<!>},<,au!!{>},{{{<!!x<!>,<<!>>}},{<!!!>!!!!!>},<!>,<ueie!>,<!!i!>},<>}}}}}},{{{<e!>!!u!!!>!>},<u<ua!ao>},{},{<a!!e!>u,!>,<}}!!!>,<>}},{{<}!>,<x>,{<ox>}},{<u!>!>!!oi!!!>xox!!ie{>,{{<!!!!!!,!!!>,<!!ux>,<}!>},<}!>,<a!>x!>,<!>!!!>!!!>},<!>,<e>}}}},{{{<o!!!>a!>},<!>,<}!!!>},<!}!!!!!>!>},<o!x,{>}}}},{{{{<x!ex!!!>!>,<!!!>!>,<o,xai!,!>,<>}},{{},{}},{{<!,,ax,!>xo<eu}e!!!>,<!!!!!!!>ia!>},<!!}>},{<o!!!>,{<xx!>},<>}}}},{{{{}},{{<!>,!>,<ax!>},<ee!!!>io>},<}!!!>,<!!eexe!!!>x}!>},<,!!!!aa>},{{<!!!>},<}!!,o!i,!>,<!>},<}<}!>e>,{<<!>},<x!!<>}},{{{{<!>},<}o!!x!>>,{<!>},<!!!<x!>},<>}},<e!!!>,<!!!>e!>,<x!!!!!>!!!>,>},<i!,u!!!!!}!>},<!}xx!>o!>,<u!!!!!>>},<,!!!>u<!>>}}},{{{{<a!!{!!ox!}!!o!!!>},<{a!>a>},<!>},<eu!>,<xi!!!>i!ai<>}},{{{}}}}}}}"
        
        //let indata = "{{{},{},{{}}}}"
        var indataChars = [Character]()
        var tempIndataChars = [Character]()
        
        // Fyll indataChars med alla tecken i indata
        for char in indata{
            indataChars.append(char)
        }
        
        //ta bort utrop och tecken efter
        var utropFöre = false
        for index in 0...indataChars.count-1{
            
            if indataChars[index] == "!"{
                utropFöre = true
                indataChars[index + 1] = "x"
            } else if utropFöre{
                utropFöre = false
                
            } else {
                tempIndataChars.append(indataChars[index])
            }
            
        }
        print(String(tempIndataChars))
        indataChars.removeAll()
        
        // remove garbage
        
        var foundLessThan = false
        var countGarbage = 0
        var startIndexGarbage = 0
        var stopIndexGarbage = 0
        
        for index in 0...tempIndataChars.count-1{
            if tempIndataChars[index] == "<"{
                if !foundLessThan {
                    startIndexGarbage = index
                }
                foundLessThan = true
            }
            
            if foundLessThan {
                if tempIndataChars[index] == ">"{
                    foundLessThan = false
                    stopIndexGarbage = index - 1
                    countGarbage += stopIndexGarbage - startIndexGarbage
                    stopIndexGarbage = 0
                    startIndexGarbage = 0
                }
            } else {
                indataChars.append(tempIndataChars[index])
                //print(index)
            }
        }
        
       // print(String(indataChars))
        
        // count score
        
        var level = 0
        var totalCount = 0
        
        for index in 0...indataChars.count-1{
            if indataChars[index] == "{"{
                level += 1
                totalCount += level
            } else if indataChars[index] == "}" {
                level -= 1
               // if level < 0 {
                //    level = 0
               // }
                
                
                
            }
        }
        
        print(totalCount)
        print(countGarbage)
        
        
        
        
    }
    @IBAction func btn8Dec(_ sender: Any) {
        var highestEver = 0
        func makeTest(Operation: String) ->(Int,Int)->Bool{
            switch Operation {
            case "==":
                return {$0 == $1 }
            case ">":
                return {$0 > $1 }
            case "<":
                return {$0 < $1 }
            case "!=":
                return {$0 != $1 }
            case "<=":
                return {$0 <= $1 }
            case ">=":
                return {$0 >= $1 }
            default:
                return {$0 >= $1 }
            }
            
        }
        
        func addOrDec(Operation:String)->((Int,Int)->Int){
            
            if Operation == "inc" {
                return {$1+$0}
            } else {
                return {$0-$1}
            }
            
        }
        
        
        let test = makeTest(Operation: ">=")
        
        let calculate = addOrDec(Operation: "dec")
        
        print(test(1,2))
        print(calculate(1,2))
        let indata = readFile(fileName: "dec8")
        var doOperation = false
        var register = [String:Int]()
        
        for index in 0...indata.count-2{
            let registerToChange = indata[index][0]
            let registerOperation = addOrDec(Operation: indata[index][1])
            let registerOperator = Int(indata[index][2])
            //if-rad är rad 3
            let registerNameTest = indata[index][4]
            let testFunction = makeTest(Operation: indata[index][5])
            let testValue = Int(indata[index][6])
            
            if let registerValue = register[registerNameTest]{
                doOperation = testFunction(registerValue,testValue!)
            } else {
                register[registerNameTest] = 0
                doOperation = testFunction(0,testValue!)
            }
            
            if doOperation{
                if let registerValueToChange = register[registerToChange]{
                    register[registerToChange] = registerOperation(registerValueToChange, registerOperator!)
                } else {
                    register[registerToChange] = registerOperation(0, registerOperator!)
                    
                }
                if register[registerToChange]! > highestEver{
                    highestEver = register[registerToChange]!
                }
            }
            
           
        }
        
        print(register as Any)
        print(highestEver)
        
        
        
    }
    
}

