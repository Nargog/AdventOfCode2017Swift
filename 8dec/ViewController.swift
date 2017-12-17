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

