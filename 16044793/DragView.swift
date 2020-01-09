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
        
        let halfx = self.bounds.midX
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min(W*0.20 - halfx, newCenter.x)
        
        let halfy = self.bounds.midY
        newCenter.y = max(halfy + H*0.25, newCenter.y)
        newCenter.y = min(H*0.75 - halfy, newCenter.y)
        
        self.center = newCenter
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let currentLocation = touches.first?.location(in: self)
        
        
        self.center = lastLocation!
        
        self.myDelegate?.viewBallSpawn()
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
