//
//  ViewController.swift
//  MultiplicationTable
//
//  Created by huangy on 6/21/16.
//  Copyright © 2016 DerekHuang. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var reciteField: UITextField!
    @IBOutlet weak var equationField: UITextField!
    @IBOutlet var answerButtons: Array<UIButton> = []
    @IBOutlet var edgeButtons : Array< UIButton > = []
   
    
    var audioPlayer : AVAudioPlayer? = nil
    
    var timer = NSTimer()
    
    var startCol : Int = 1
    var startRow : Int = 1
    var animCol : Int = 1
    var animRow : Int = 1

    var edgeButtonMap = [ Int: Int ]()
    var answerButtonMap = [ Int: Int ]()
    
    let wordMap = [ 1: "One", 2: "Two", 3: "Three", 4: "Four", 5 : "Five", 6: "Six", 7: "Seven", 8 : "Eight", 9 : "Nine", 10 : "Ten",
                    12 : "Twelve", 14 : "Fourteen", 15 : "Fifteen", 16: "Sixteen", 18 : "Eighteen", 20 : "Twenty", 21 : "Tweenty-One",
                    24 : "Twenty-Four", 25 : "Twenty-Five", 27 : "Twenty-Seven", 28 : "Twenty-Eight", 30 : "Thirty", 32 : "Thirty-Two",
                    35 : "Thirty-Five", 36 : "Thirty-Six", 40 : "Fourty", 42 : "Fourty-Two", 45 : "Fourty-Five", 48 : "Fourty-Eight",
                    49 : "Fourty-Nine", 54 : "Fifty-Four", 56 : "Fifty-Six", 63 : "Sixty-Three", 64 : "Sixty-Four", 72 : "Seventy-Two",
                    81 : "Eighty-One"
                    ]
    
    let audioMap = [
        11 : "111",  12 : "122",  13 : "133",  14 : "144",  15 : "155",  16 : "166",  17 : "177",  18 : "188",  19 : "199",
        22 : "224",  23 : "236",  24 : "248",  25 : "2510", 26 : "2612", 27 : "2714", 28 : "2816", 29 : "2918",
        33 : "339",  34 : "3412", 35 : "3515", 36 : "3618", 37 : "3721", 38 : "3824", 39 : "3927",
        44 : "4416", 45 : "4520", 46 : "4624", 47 : "4728", 48 : "4832", 49 : "4936",
        55 : "5525", 56 : "4630", 57 : "5735", 58 : "5840", 59 : "5945",
        66 : "6636", 67 : "6742", 68 : "6848", 69 : "6954",
        77 : "7749", 78 : "7856", 79 : "7963",
        88 : "8864", 89 : "8972",
        99 : "9981"
    ]
    
    @IBAction func clearButtonPushed(sender: UIButton) {
        //print( "clear button pushed")
        //print( sender.titleLabel!.text!)
        clearSelected(true)
    }
    
    func clearSelected(clearTimer: Bool = false)
    {
        for ( _, value ) in edgeButtons.enumerate()
        {
            value.selected = false
        }
        for (_, value) in answerButtons.enumerate()
        {
            value.selected = false
        }
        self.equationField.text? = ""
        self.reciteField.text? = ""
        
        if(clearTimer)
        {
            timer.invalidate()
        }
    }
    
    @IBAction func edgeButtonPushed(sender: UIButton) {
        // print( "edge button pushed")
        
        let key = sender.tag
        assert( key == Int(sender.titleLabel!.text!) ||
            (key/100) == Int(sender.titleLabel!.text!))
        
        clearSelected(true)
        
        if( key/100 == 0)
        {
            startCol = key
            startRow = key
        }
        else
        {
            startCol = 1
            startRow = key/100
        }
       
        animCol = startCol
        animRow = startRow
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewController.onTimer(_:)), userInfo: nil, repeats: true)
        
        timer.fire()
      //  let index = edgeButtonMap[key]
      //  assert( edgeButtons[index!] == sender )

        //edgeButtons[index!].selected = true
    }
    
   
    func onTimer(timerArg:NSTimer!) {
//        print("Timer here", timerArg == timer)
        
        let answerKey =  animCol * 10 + animRow
        
        if( animCol < startRow )
        {
            animCol+=1
        }
        else if( animRow <= 9)
        {
            animRow+=1
        }
        else
        {
            clearSelected(true)
            return()
        }
        
        clearSelected()
        let index = answerButtonMap[answerKey]
        answerButtonAction( answerButtons[index!])
    }
    
    func answerButtonAction(sender: UIButton)
    {
        let answer = Int(sender.titleLabel!.text!)
        let key = sender.tag
        let row = key % 10;
        let col = key / 10;
        
        assert( col * row == answer )
        let index = answerButtonMap[key]
        assert( answerButtons[index!] == sender )
        
        let display = "\(col) x \(row) = \(answer!)"
        self.equationField.text? = display
        
        let a = self.wordMap[col]!
        let b = self.wordMap[row]!
        let c = self.wordMap[answer!]!
        let recite = "\(a) \(b) \(c)"
        self.reciteField.text? = recite
        sender.selected = true
        let colIndex = edgeButtonMap[col]
        edgeButtons[colIndex!].selected = true
        let rowIndex = edgeButtonMap[row*100]
        edgeButtons[rowIndex!].selected=true
        
        if(audioPlayer != nil && audioPlayer!.playing)
        {
            audioPlayer!.stop()
            audioPlayer!.currentTime = 0
        }
    
        let audioEnable = false
        
        if(!audioEnable)
        {
            return
        }
        
        let file = audioMap[key]
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "m4a")
        
        if(path != nil)
        {
            let sound = NSURL(fileURLWithPath: path!)
        
            do{
                try audioPlayer = AVAudioPlayer(contentsOfURL: sound)
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            }
            catch
            {}
        }
    }
    
    @IBAction func answerButtonPushed(sender: UIButton) {
//        print( "answer", sender.tag,"button pushed")
//        print( "answer ", sender.titleLabel!.text!, " pushed" )
        clearSelected(true)
     
        answerButtonAction(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for ( index, value ) in edgeButtons.enumerate()
        {
            edgeButtonMap[value.tag] = index
        }
        for (index, value) in answerButtons.enumerate()
        {
            answerButtonMap[value.tag] = index
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

