//
//  ReplayViewController.swift
//  16044793
//
//  Created by Suhail Remtulla on 10/01/2020.
//  Copyright © 2020 Suhail Remtulla. All rights reserved.
//

import UIKit



class ReplayViewController: UIViewController {
    
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var replayButtom: UIImageView!
    var gameOver = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        replayButtom = UIImageView(image: nil)
        replayButtom.image = UIImage(named: "replay.png")
        replayButtom.frame = CGRect(x: UIScreen.main.bounds.width * 0.50, y: UIScreen.main.bounds.midY * 0.50, width: 75, height: 75)
        self.view.addSubview(replayButtom)
        //replayButtom.append(replayButtom)
        
        gameOver = UILabel.init()
        gameOver.frame = CGRect(x: W * 0.30, y: H * 0.00, width: 200, height: 60)
        gameOver.text = "GAME OVER"
        gameOver.textAlignment = .center
        gameOver.textColor = UIColor.black
        gameOver.font = UIFont(name: "verdana", size: 25.0)
        
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
