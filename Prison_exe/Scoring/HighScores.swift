//
//  HighScores.swift
//  HighScoresTest
//
//  Created by Ryan Dieno on 2018-04-17.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation

class HighScores {
    
    var highScores = [Dictionary<String, Any>]()
    
    init() {
        //clearHighScores()
        
        /*inputHighScore(score: 10, name: "Player5")
        inputHighScore(score: 20, name: "Player4")
        inputHighScore(score: 30, name: "Player3")
        inputHighScore(score: 40, name: "Player2")
        inputHighScore(score: 50, name: "Player1")
        saveHighScores()*/
        //printHighScores()
        
        loadHighScores()
    }
    
    
    func inputHighScore(score: Int, name: String) {
        let highScoreEntry = [
            "score": score,
            "date": NSDate(),
            "name": name
            ] as [String : Any]
        
        var index: Int = 0
        
        for(dict) in highScores {
            if(dict["score"] as! Int > score) {
                index += 1
            }
        }

        if(index < 5) {
            highScores.insert(highScoreEntry, at: index)
        }
    }
    
    func saveHighScores() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let writePath = NSURL(fileURLWithPath: paths).appendingPathComponent("highscores.plist")?.path
        /*let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: writePath!)))
        {
            let bundle : String = Bundle.main.path(forResource: "highscores", ofType: "plist")!
            do {
               try fileManager.copyItem(atPath: bundle, toPath: writePath!)
            } catch {
                print("Unexpected error: \(error).")
                
            }
        }*/
        
        (self.highScores as NSArray).write(toFile: writePath!, atomically: true)
    }
    
    func loadHighScores() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let writePath = NSURL(fileURLWithPath: paths).appendingPathComponent("highscores.plist")?.path
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: writePath!)) {
            self.highScores = NSArray.init(contentsOfFile: writePath!) as! [Dictionary<String, Any>]
        } else {
            inputHighScore(score: 10, name: "Player5")
            inputHighScore(score: 20, name: "Player4")
            inputHighScore(score: 30, name: "Player3")
            inputHighScore(score: 40, name: "Player2")
            inputHighScore(score: 50, name: "Player1")
            saveHighScores()
        }
    
    }
    
    func printHighScores() {
        for(dict) in highScores {
            print(dict["name"]!, ": ", dict["score"]!)
        }
    }
    
    func clearHighScores() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let writePath = NSURL(fileURLWithPath: paths).appendingPathComponent("highscores.plist")?.path
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: writePath!) {
                try fileManager.removeItem(atPath: writePath!)
            }
        } catch {
            print(error)
        }
    }
}
