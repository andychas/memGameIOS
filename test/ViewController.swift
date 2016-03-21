//
//  ViewController.swift
//  test
//
//  Created by Andrey on 15/03/2016.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBAction func resetGame(sender: AnyObject) {
        
        // re enable all cells since reloadData() doesn't do it
        for c in collectionViewOutlet.visibleCells() as [UICollectionViewCell] {
            c.userInteractionEnabled = true
        }
        array.shuffleInPlace()
        collectionViewOutlet.reloadData()
        score = 0
        scoreLabel.text = "Score: \(score)"
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    var score = 0
    var array: [String] = []
    var firstClick = true
    var isChanging = false
    var bg:String = "bg.png"
    var cell:CollectionViewCell? = nil
    var lastCell:CollectionViewCell? = nil
    var startTime = NSTimeInterval()
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        array = ["pinguin.png","snow.png","star.png","sock.png","santa.png","santaGifts.png","deer.png","piter.png",
            "angel.png","bells.png","owl.png","snowMan.png"]
        array += array
        
        array.shuffleInPlace()
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.image.image = UIImage(named: bg)
        cell.name = array[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell
        cell?.image.image = UIImage(named: array[indexPath.row])
        if (!firstClick){
            
            if(lastCell?.name == cell?.name){
                cell?.userInteractionEnabled = false
                lastCell?.userInteractionEnabled = false
                lastCell = cell
                updateScore(5)
            }
            else{
                updateScore(-1)
                collectionViewOutlet.userInteractionEnabled = false
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("turnOver"), userInfo: nil, repeats: false)
                
            }
        }else{
            cell?.userInteractionEnabled = false
            lastCell = cell
        }
        firstClick = !firstClick
    }
    
    func updateScore(number: Int){
        guard score+number>=0 else{
            return
        }
        score+=number
        scoreLabel.text = "Score: \(score)"
    }
    
    func turnOver(){
        lastCell?.userInteractionEnabled = true
        cell?.image.image = UIImage(named: bg)
        lastCell?.image.image = UIImage(named: bg)
        lastCell = cell
        collectionViewOutlet.userInteractionEnabled = true
   }
    func updateTime(){
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let fraction = UInt8(elapsedTime * 100)

        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
}
