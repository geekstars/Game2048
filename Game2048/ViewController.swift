//
//  ViewController.swift
//  Game2048
//
//  Created by Hoàng Minh Thành on 8/30/16.
//  Copyright © 2016 Hoàng Minh Thành. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var score: UILabel!
    
    var b = Array(count:4,repeatedValue:Array(count:4,repeatedValue:0))
    var lose = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let directions:[UISwipeGestureRecognizerDirection] = [.Right,.Left,.Up,.Down]
        for direction in directions
        {
            let gesture = UISwipeGestureRecognizer(target: self,action: #selector(respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        randomNum(-1)
    }
    func randomNum(type: Int)
    {
        if(!lose)
        {
            switch(type)
            {
                case 0 : left()
                case 1 : right()
                case 2 : Up()
                case 3 : down()
                default : break
            }
        }
        if (checkRandom())
        {
            var rnlableX  = arc4random_uniform(4)
            var rnlableY = arc4random_uniform(4)
            let rdNum = arc4random_uniform(2) == 0 ? 2 : 4;
            while (b[Int(rnlableX)][Int(rnlableY)] != 0)
            {
                rnlableX = arc4random_uniform(4)
                rnlableY = arc4random_uniform(4)
            }
            b[Int(rnlableX)][Int(rnlableY)] = rdNum
            let numlabel = 100 + (Int(rnlableX) * 4) + Int(rnlableY)
            ConvertNumLabel(numlabel, value: String(rdNum))
            transfer()
        }
        else if (checkLose())
        {
            lose = true
            let alert = UIAlertController(title: "Game Over", message: "You Lose", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func checkRandom() -> Bool
    {
        for i in 0..<4
        {
            for j in 0..<4
            {
                if(b[i][j] == 0)
                {
                    return true
                }
            }
        }
        return false
    }
    func checkLose() -> Bool
    {
        var dem = 0
        for i in 0..<4
        {
            for j in 0..<4
            {
                // Biên trên bên trái
                if (i == 0 && j == 0)
                {
                    if b[i][j] == b[i][j+1] || b[i][j] == b[i+1][j]
                    {
                        dem = dem + 1
                    }
                }
                else
                {
                    // Biên trên bên phải
                    if (i == 0 && j == 3)
                    {
                        if b[i][j] == b[i][j-1] || b[i][j] == b[i+1][j]
                        {
                            dem = dem + 1
                        }
                    }
                    else
                    {
                        // Biên dưới bên trái
                        if (i == 3 && j == 0)
                        {
                            if b[i][j] == b[i-1][j] || b[i][j] == b[i][j+1]
                            {
                                dem = dem + 1
                            }
                        }
                        else
                        {
                            // Biên dưới bên phải
                            if (i == 3 && j == 3)
                            {
                                if b[i][j] == b[i][j-1] || b[i][j] == b[i-1][j]
                                {
                                    dem = dem + 1
                                }
                            }
                            else
                            {
                                if (i == 0 && j > 0)
                                {
                                    if (b[i][j] == b[i][j-1] || b[i][j] == b[i][j+1])
                                    {
                                        dem += 1
                                    }
                                }
                                else
                                {
                                    if (i > 0 && j == 0)
                                    {
                                        if b[i][j] == b[i-1][j] || b[i][j] == b[i+1][j]
                                        {
                                            dem += 1
                                        }
                                    }
                                    else
                                    {
                                        if (i == 3 && j > 0)
                                        {
                                            if b[i][j] == b[i][j-1] || b[i][j] == b[i][j+1]
                                            {
                                                dem += 1
                                            }
                                        }
                                        else
                                        {
                                            if i > 0 && j == 3
                                            {
                                                if b[i][j] == b[i-1][j] || b[i][j] == b[i+1][j]
                                                {
                                                    dem += 1
                                                }
                                            }
                                            else
                                            {
                                                if b[i][j] == b[i-1][j] || b[i][j] == b[i][j-1] || b[i][j] == b[i][j+1] || b[i][j] == b[i+1][j]
                                                {
                                                    dem = dem + 1
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if dem > 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    func ConvertNumLabel(numlabel:Int,let value: String)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    func changeBackColor(numlabel:Int,color:UIColor)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }
    func transfer()
    {
        for i in 0..<4
        {
            for j in 0..<4
            {
                let numlabel = 100 + (i*4) + j
                ConvertNumLabel(numlabel,value: String(b[i][j]))
                switch b[i][j]
                {
                    case 2,4: changeBackColor(numlabel, color: UIColor.cyanColor())
                    case 8,16: changeBackColor(numlabel, color: UIColor.greenColor())
                    case 16,32:changeBackColor(numlabel, color: UIColor.orangeColor())
                    case 64:changeBackColor(numlabel, color: UIColor.redColor())
                    case 128,256,512:changeBackColor(numlabel, color: UIColor.yellowColor())
                    case 1024,2048:changeBackColor(numlabel, color: UIColor.purpleColor())
                    default: changeBackColor(numlabel, color: UIColor.brownColor())
                }
            }
        }
    }
    func respondToSwipeGesture(gesture:UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                randomNum(0)
            case UISwipeGestureRecognizerDirection.Right:
                randomNum(1)
            case UISwipeGestureRecognizerDirection.Up:
                randomNum(2)
            case UISwipeGestureRecognizerDirection.Down:
                randomNum(3)
            default:
                break
            }
        }
    }
    func Up()
    {
        for col in 0 ..< 4
        {
            var check = false
            for row in 1..<4
            {
                var tx = row
                if(b[row][col] == 0 )
                {
                    continue
                }
                for var rowc = row - 1; rowc != -1; rowc = rowc - 1
                {
                    if(b[rowc][col] != 0 && b[rowc][col] != b[row][col] || check)
                    {
                        break
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if(b[row][col] == b[tx][col])
                {
                    check = true
                    GetScore(b[tx][col])
                    b[tx][col] *= 2
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0
            }
        }
    }
    func down()
    {
        for col in 0 ..< 4
        {
            var check = false
            for row in 0 ..< 4
            {
                var tx = row
                
                if (b[row][col] == 0)
                {
                    continue
                }
                for rowc in row + 1 ..< 4
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break;
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[tx][col] == b[row][col])
                {
                    check = true
                    GetScore(b[tx][col])
                    b[tx][col] *= 2
                    
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func left()
    {
        for row in 0 ..< 4
        {
            var check = false
            for col in 1 ..< 4
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for var colc = col - 1; colc != -1; colc -= 1
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty]=b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }
    func right()
    {
        for row in 0 ..< 4
        {
            var check = false
            for var col = 3; col != -1; col -= 1
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for colc in col + 1 ..< 4
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }

    @IBAction func action_reset(sender: UIButton) {
        lose = false
        score.text = "0"
        for i in 0..<4
        {
            for j in 0..<4
            {
                b[i][j] = 0
                let numlabel = 100 + (i*4) + j
                ConvertNumLabel(numlabel,value: "0")
                changeBackColor(numlabel, color: UIColor.brownColor())
            }
        }
    }
    func GetScore(value: Int)
    {
        score.text = String(Int(score.text!)! + value)
    }
}

