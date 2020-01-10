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
    var birdView: UIImageView!
    var replayButton: UIButton!
    var birdPicture: UIImageView!
    var ballsArray = [UIImageView]();
    var birdsArray = [UIImageView]();
    var birdPictures = ["bird1.png", "bird4.png", "bird5.png"] // array of bird images
    
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var timer = 5
    var gameScore = 0
    
    var runningTimer = false
    
    @IBOutlet weak var aimView: DragView!
    
    func randomBird(){
        //random number generated
        print("hello")
        let randNumbBird = Int.random(in: 0...2)
    
        //random bird spawn
        birdPicture = UIImageView(image: nil)
        birdPicture.image = UIImage(named: birdPictures[randNumbBird])
        birdPicture.frame = CGRect(x: UIScreen.main.bounds.width * 0.87, y: UIScreen.main.bounds.midY * 0.90, width: 75, height: 75)
        //birdImage.frame = CGRectx: (UIScreen.main.bounds.width * 0.87, y: randNumbLocation, width 75, height 75)
        var doesintersect = false;
        
        for bird in self.birdsArray{
            if birdPicture.frame.intersects(bird.frame){
                doesintersect = true;
            }
        }
        if doesintersect == false{
            self.view.addSubview(birdPicture)
            birdsArray.append(birdPicture)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aimView.myDelegate = self
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        //Bird 1 Image Added
        birdView = UIImageView(image: nil)
        birdView.image = UIImage(named: "bird1.png")
        birdView.frame = CGRect(x: UIScreen.main.bounds.width * 0.89, y: UIScreen.main.bounds.midY * 0.09, width: 75, height: 75)
        self.view.addSubview(birdView)
        birdsArray.append(birdView)
        
        //Bird 2 image added
        let birdTwo = UIImageView(image: nil)
        birdTwo.image = UIImage(named: "bird4.png")
        birdTwo.frame = CGRect(x: UIScreen.main.bounds.width * 0.89, y: UIScreen.main.bounds.midY * 0.50, width: 75, height: 75)
        self.view.addSubview(birdTwo)
        birdsArray.append(birdTwo)
        
        //Bird 3 image added
        let birdThree = UIImageView(image: nil)
        birdThree.image = UIImage(named: "bird5.png")
        birdThree.frame = CGRect(x: UIScreen.main.bounds.width * 0.89, y: UIScreen.main.bounds.midY * 0.90, width: 75, height: 75)
        self.view.addSubview(birdThree)
        birdsArray.append(birdThree)
        
        scoreLabel = UILabel.init()
        scoreLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        scoreLabel.text = "Current Score: "
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.black
        scoreLabel.font = UIFont(name: "verdana", size: 18.0)
        
        self.view.addSubview(scoreLabel)
        
        timerLabel = UILabel.init()
        timerLabel.frame = CGRect(x: W * 0.30, y: H * 0.00, width: 200, height: 60)
        timerLabel.text = "Time Left: "
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.black
        timerLabel.font = UIFont(name: "verdana", size: 18.0)
        
        self.view.addSubview(timerLabel)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in self.timer = self.timer - 1
            self.timerLabel.text = "Time Left: " + String(self.timer)
            
            
            if self.timer == 0 {
                timer.invalidate()
                self.runningTimer = false//when timer hits 0 end timer
                
                //adds a replay button when timer runs out
                let replayButtonImage = UIImage(named: "replay.png") as UIImage?
                self.replayButton = UIButton(type:UIButton.ButtonType.custom) as UIButton
                self.replayButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.38, y: UIScreen.main.bounds.midY * 0.68, width: 180, height: 110)
                self.replayButton.setImage(replayButtonImage, for: .normal)
                self.view.addSubview(self.replayButton)
                
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
        dynamicAnimator.addBehavior(collisionBehavior)
        
        collisionBehavior.addBoundary(withIdentifier: "leftBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 0.0), to: CGPoint(x: self.W * 0.0, y: self.H * 1.0))
        collisionBehavior.addBoundary(withIdentifier: "topBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 0.0), to: CGPoint(x: self.W * 1.0, y: self.H * 0.0))
        collisionBehavior.addBoundary(withIdentifier: "bottomBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 1.0), to: CGPoint(x: self.W * 1.0, y: self.H * 1.0))
        
        birdCollision = UICollisionBehavior(items: [])
        
        dynamicAnimator.addBehavior(birdCollision)
        
        birdCollision.action = {
            for ball in self.ballsArray{
                for bird in self.birdsArray{
                    if ball.frame.intersects(bird.frame){
                        let before = self.view.subviews.count
                        bird.removeFromSuperview();
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
