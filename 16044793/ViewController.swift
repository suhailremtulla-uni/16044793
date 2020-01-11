//
//  ViewController.swift
//  16044793
//
//  Created by Suhail Remtulla on 11/11/2019.
//  Copyright © 2019 Suhail Remtulla. All rights reserved.
//

import UIKit

protocol subviewDelegate{
    func viewBallSpawn()
    func updateAngle(x:Int, y:Int)
    func randomBirdSpawn()
    
}

class ViewController: UIViewController, subviewDelegate {
    
    
    var scoreLabel = UILabel()
    var timerLabel = UILabel()
    
    var dynamicAnimator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    var birdCollision: UICollisionBehavior!
    var angleX: Int!
    var angleY: Int!
    var ballView: UIImageView!
    var gameOver: UIImageView!
    var replayButton: UIButton!
    var birdPicture: UIImageView!
    var ballsArray: [UIImageView] = []
    
    var birdsArray = [UIImage(named: "bird1.png")!, UIImage(named: "bird4.png")!, UIImage(named: "bird5.png")!] // array of bird images
    var birdsArrayUI: Array<UIImageView> = []
    
    
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var timer = 20
    var gameScore = 0
    
    var runningTimer = false
    
    @IBOutlet weak var aimView: DragView!
    
    
    
    func randomBirdSpawn(){//calls and spawns random birds in random locations
        let birdAmount = 5//amount of birds in the line
        let sizeOfBird = Int(self.H)/birdAmount - 5
        
        for index in 0...1000{
            let when = DispatchTime.now() + (Double(index)/2)//how often bird spawns
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                while true {
                    let randomLoc = Int(self.H)/birdAmount * Int.random(in: 0...birdAmount)//random place of bird spawning
                    
                    let viewBird = UIImageView(image: nil)
                    viewBird.image = self.birdsArray.randomElement()
                    viewBird.frame = CGRect(x: self.W-CGFloat(sizeOfBird), y: CGFloat(randomLoc), width: CGFloat(sizeOfBird), height: CGFloat(sizeOfBird))
                    self.view.addSubview(viewBird)
                    for birdImgView in self.birdsArrayUI{
                        if viewBird.frame.intersects(birdImgView.frame){
                            viewBird.removeFromSuperview()
                            continue
                        }
                    }
                    self.birdsArrayUI.append(viewBird)
                    break;
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView(image: UIImage(named: "project_background.jpg"))
        background.frame = UIScreen.main.bounds
        self.view.sendSubviewToBack(background)
        self.view.addSubview(background)
        self.view.bringSubviewToFront(scoreLabel)
        self.view.bringSubviewToFront(timerLabel)
        self.view.bringSubviewToFront(aimView)
        
        aimView.myDelegate = self
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        collisionBehavior = UICollisionBehavior(items: ballsArray)
        birdCollision = UICollisionBehavior(items: [])
        
        //creates label for the score
        scoreLabel = UILabel.init()
        scoreLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 60)//sets location and size
        scoreLabel.text = "Current Score: "//text displayed
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont(name: "verdana", size: 18.0)
        
        self.view.addSubview(scoreLabel)
        
        timerLabel = UILabel.init()
        timerLabel.frame = CGRect(x: W * 0.30, y: H * 0.00, width: 200, height: 60)
        timerLabel.text = "Time Left: "
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.white
        timerLabel.font = UIFont(name: "verdana", size: 18.0)
        
        self.view.addSubview(timerLabel)
        
        randomBirdSpawn()//calls randomBird function to create and spawn random birds
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in self.timer = self.timer - 1
            self.timerLabel.text = "Time Left: " + String(self.timer)
            
            
            if self.timer == 0 {
                timer.invalidate()
                self.runningTimer = false//when timer hits 0 end timer
                
                //adds a replay button when timer runs out
                let replayButtonImage = UIImage(named: "replay.png") as UIImage?
                self.replayButton = UIButton(type:UIButton.ButtonType.custom) as UIButton
                self.replayButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.38, y: UIScreen.main.bounds.midY * 0.95, width: 180, height: 110)
                self.replayButton.setImage(replayButtonImage, for: .normal)
                self.view.addSubview(self.replayButton)
                
                //add the game over image to the display
                self.gameOver = UIImageView(image: nil)
                self.gameOver.image = UIImage(named: "GameOver.jpg")
                self.gameOver.frame = CGRect(x: UIScreen.main.bounds.width * 0.42, y: UIScreen.main.bounds.midY * 0.48, width: 120, height: 75)
                self.view.addSubview(self.gameOver)
                
                //removes aim from the view
                self.aimView.removeFromSuperview();
                
            }
        }
        
    }
    
    func updateAngle(x: Int, y:Int){
        angleX = x
        angleY = y
    }
    
    func viewBallSpawn() {
        
        ballView = UIImageView(image: nil)
        ballView.image = UIImage(named: "ball.png")
        ballView.frame = CGRect(x:125, y:150, width: 40, height: 40)
        self.view.addSubview(ballView)
        ballsArray.append(ballView)
        
        
        dynamicItemBehavior.addItem(ballView)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: angleX * 5, y: angleY * 5), for: ballView)
        
        collisionBehavior = UICollisionBehavior(items: ballsArray)
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        collisionBehavior.addBoundary(withIdentifier: "leftBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 0.0), to: CGPoint(x: self.W * 0.0, y: self.H * 1.0))
        collisionBehavior.addBoundary(withIdentifier: "topBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 0.0), to: CGPoint(x: self.W * 1.0, y: self.H * 0.0))
        collisionBehavior.addBoundary(withIdentifier: "bottomBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 1.0), to: CGPoint(x: self.W * 1.0, y: self.H * 1.0))
        
        birdCollision = UICollisionBehavior(items: [])
        
        dynamicAnimator.addBehavior(birdCollision)
        
        dynamicAnimator.addBehavior(collisionBehavior)
        
        birdCollision.action = {
            for ball in self.ballsArray{
                for bird in self.birdsArrayUI{
                   let index = self.birdsArrayUI.firstIndex(of: bird)
                    if ball.frame.intersects(bird.frame){
                        let before = self.view.subviews.count
                        bird.removeFromSuperview()
                        self.birdsArrayUI.remove(at: index!)
                        let after = self.view.subviews.count

                        if(before != after){
                            self.gameScore += 1
                            self.scoreLabel.text = "Current Score = " + String(self.gameScore)
                        }

                    }
                }
            }
        }
    
    }
    
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return.landscape
    }
}
