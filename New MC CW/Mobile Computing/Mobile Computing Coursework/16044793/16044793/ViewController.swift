//
//  ViewController.swift
//  16044793
//
//  Created by Suhail Remtulla on 11/11/2019.
//  Copyright © 2019 Suhail Remtulla. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

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
    //var aimView: UIImageView!
    var gameOver: UIImageView!
    var replayButton: UIButton!
    var birdPicture: UIImageView!
    var ballsArray: [UIImageView] = []
    var aimView = DragView(image: nil) //links aimView with DragView
    var gunSoundEffect: AVAudioPlayer?
    
    var birdsArray = [UIImage(named: "bird1.png")!, UIImage(named: "bird4.png")!, UIImage(named: "bird5.png")!] // array of bird images
    var birdsArrayUI: Array<UIImageView> = []
    
    //assigns the UIscreen boundaries to W and H
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var timer = 20//sets the timer to 20
    var gameScore = 0//game score starts at 0
    
    var runningTimer = false
    
    
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
                    self.birdsArrayUI.append(viewBird)//adds the bird images to the birdsArrayUI array
                    break;
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adds a custom background to the game
        let background = UIImageView(image: UIImage(named: "project_background.jpg"))
        background.frame = UIScreen.main.bounds
        self.view.sendSubviewToBack(background)
        self.view.addSubview(background)
        //bring the aimview, scorelabel and the timerlabel in front of the background
        self.view.bringSubviewToFront(scoreLabel)
        self.view.bringSubviewToFront(timerLabel)
        self.view.bringSubviewToFront(aimView)
        
        aimView.myDelegate = self
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        collisionBehavior = UICollisionBehavior(items: ballsArray)
        birdCollision = UICollisionBehavior(items: [])
        
        //creates the aimView --------------------------
        aimView.image = UIImage(named: "aim.png")
        aimView.frame = CGRect(x: W * 0.05, y:H * 0.40, width: 75, height: 75)
        aimView.isUserInteractionEnabled = true
        self.view.addSubview(aimView)
        
        //creates label for the score
        scoreLabel = UILabel.init()
        scoreLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 60)//sets location and size
        scoreLabel.text = "Current Score: "//text displayed
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont(name: "verdana", size: 20.0)
        
        self.view.addSubview(scoreLabel)
        
        //creates the label for the timer
        timerLabel = UILabel.init()
        timerLabel.frame = CGRect(x: W * 0.30, y: H * 0.00, width: 200, height: 60)
        timerLabel.text = "Time Left: "
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.white
        timerLabel.font = UIFont(name: "verdana", size: 20.0)
        
        self.view.addSubview(timerLabel)
        
        randomBirdSpawn()//calls randomBird function to create and spawn random birds
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in self.timer = self.timer - 1
            self.timerLabel.text = "Time Left: " + String(self.timer)
            
            //timer before the game ends
            if self.timer == 0 {
                timer.invalidate()
                self.runningTimer = false//when timer hits 0 end timer
                
                //adds a replay button when timer runs out
                //creates the replay button with an image
                let replayButtonImage = UIImage(named: "replay.png") as UIImage?
                self.replayButton = UIButton(type:UIButton.ButtonType.custom) as UIButton
                self.replayButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.38, y: UIScreen.main.bounds.midY * 0.95, width: 180, height: 110)
                self.replayButton.setImage(replayButtonImage, for: .normal)
                //bring the replay button to the front
                self.view.addSubview(self.replayButton)
                
                //--------------calls replay interactive function when replay button is clicked
                self.replayButton.addTarget(self, action: #selector(self.replay), for: .touchUpInside)//calls the replay function when replay button is clicked
                
                //add the game over image to the display
                //creates the game over image
                self.gameOver = UIImageView(image: nil)
                self.gameOver.image = UIImage(named: "GameOver.jpg")
                self.gameOver.frame = CGRect(x: UIScreen.main.bounds.width * 0.42, y: UIScreen.main.bounds.midY * 0.48, width: 120, height: 75)
                //brings the game over image to the front
                self.view.addSubview(self.gameOver)
                self.gameScore = 0
                
                
                //removes aim from the view
                self.aimView.removeFromSuperview();
                
            }
        }
        
    }
    
    //interactive function for replay button
    @objc func replay(){
        for replay in self.view.subviews{//loops through all the subviews and restarts them
            replay.removeFromSuperview()//takes away the replay button
            ballsArray.removeAll()//clears the ballsArray array
            //birdsArray.removeAll()
            gameScore = 0//resets the gameScore variable
            self.scoreLabel.text = "Current Score = " + String(self.gameScore)//displays the game current game score
            timer = 20//resets the timer to 20
            self.timerLabel.text = "Time Left: " + String(self.timer)//displays current time left
            self.aimView.isHidden = false
            
        }
        viewDidLoad()//calls viewDidLoad function to restart the game
    }
    
    func updateAngle(x: Int, y:Int){//updates angle with the direction the aim view is pointing in
        angleX = x
        angleY = y
    }
    
    func viewBallSpawn() {
        
        //created ball image with UIImageView
        ballView = UIImageView(image: nil)
        ballView.image = UIImage(named: "ball.png")
        ballView.frame = CGRect(x:125, y:150, width: 40, height: 40)
        self.view.addSubview(ballView)
        ballsArray.append(ballView)
        
        
        dynamicItemBehavior.addItem(ballView)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: angleX * 5, y: angleY * 5), for: ballView)//shoots the ball in the direction of the aim view
        
        let path = Bundle.main.path(forResource: "gunSound.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            gunSoundEffect = try AVAudioPlayer(contentsOf: url)
            gunSoundEffect?.play()
        }
        catch{
            
        }
        
        //all balls collide with each other
        collisionBehavior = UICollisionBehavior(items: ballsArray)
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        
        //left, top and bottom boundaries with screen fit
        collisionBehavior.addBoundary(withIdentifier: "leftBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 0.0), to: CGPoint(x: self.W * 0.0, y: self.H * 1.0))
        collisionBehavior.addBoundary(withIdentifier: "topBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 0.0), to: CGPoint(x: self.W * 1.0, y: self.H * 0.0))
        collisionBehavior.addBoundary(withIdentifier: "bottomBorder" as NSCopying, from: CGPoint(x: self.W * 0.0, y: self.H * 1.0), to: CGPoint(x: self.W * 1.0, y: self.H * 1.0))
        
        birdCollision = UICollisionBehavior(items: [])
        
        dynamicAnimator.addBehavior(birdCollision)//collision for birds
        
        dynamicAnimator.addBehavior(collisionBehavior)//collision for balls
        
        birdCollision.action = {//bird collision behaviour
            for ball in self.ballsArray{
                for bird in self.birdsArrayUI{
                   let index = self.birdsArrayUI.firstIndex(of: bird)
                    if ball.frame.intersects(bird.frame){
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)//vibrates the phone on ball collision with the birds
                        let before = self.view.subviews.count//counts the amount of
                        bird.removeFromSuperview()//removes the bird image from the view
                        self.birdsArrayUI.remove(at: index!)
                        let after = self.view.subviews.count
                        

                        if(before != after){//compares the counts before and after the removal of the bird
                            self.gameScore += 1//imcrements the game score
                            self.scoreLabel.text = "Current Score = " + String(self.gameScore)//displays the game current game score
                        }

                    }
                }
            }
        }
    
    }
    
    //orientation is landscape
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return.landscape
    }
}
