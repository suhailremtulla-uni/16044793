//
//  DragView.swift
//  16044793
//
//  Created by Suhail Remtulla on 25/11/2019.
//  Copyright © 2019 Suhail Remtulla. All rights reserved.
//

import UIKit


class DragView: UIImageView {

    var myDelegate: subviewDelegate?
    
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var startLocation:  CGPoint?
    var lastLocation: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        startLocation = touches.first?.location(in: self)
        lastLocation = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        self.myDelegate?.updateAngle(x: Int(dx), y: Int(dy))
        
        //var newCenter = CGPoint(x : self.center.x+dx, y: self.center.y+dy)
        //let dx = currentLocation!.x - startLocation!.x
        //let dy = currentLocation!.y - startLocation!.y
        let halfx = self.bounds.midX
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min(W*0.20 - halfx, newCenter.x)
        //newCenter.x = min(self.superview!.bounds.width - 550, newCenter.x)
        
        let halfy = self.bounds.midY
        newCenter.y = max(halfy + H*0.25, newCenter.y)
        newCenter.y = min(H*0.75 - halfy, newCenter.y)
        
        //newCenter.y = max(125, newCenter.y)
        //newCenter.y = min(self.superview!.bounds.height - 125, newCenter.y)
        
        self.center = newCenter
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let currentLocation = touches.first?.location(in: self)
        
        //var newCenter = CGPoint(x: 0, y:0)
        //newCenter.x = 55
        //newCenter.y = 185
        //self.center = newCenter
        self.center = lastLocation!
        
        self.myDelegate?.viewBallSpawn()
        //ballViewSpawn.delegate() = CGPointMake(x: 55, y: 195)
        //ballViewSpawn.delegate
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
