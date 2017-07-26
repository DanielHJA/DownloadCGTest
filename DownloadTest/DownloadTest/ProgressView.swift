//
//  ProgressView.swift
//  DownloadTest
//
//  Created by Daniel Hjärtström on 2017-07-25.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var shapeLayer: CAShapeLayer?
    
    func initiateDownload(){
        
        shapeLayer = CAShapeLayer()
        shapeLayer?.lineWidth = 9.0
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.strokeColor = UIColor.green.cgColor
        shapeLayer?.lineCap = kCALineCapRound
        shapeLayer?.strokeStart = 0.0
        shapeLayer?.strokeEnd = 0.0
        
        let radius = self.frame.width * 0.2
        
        let circlePath = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius:radius, startAngle: CGFloat(Double.pi) * 3.0, endAngle:CGFloat(Double.pi) * 3.0 + CGFloat(Double.pi) * 2.0, clockwise: true)

        
        shapeLayer?.path = circlePath.cgPath
        
        self.layer.addSublayer(shapeLayer!)

    }
    
    func updateStroke(progress: CGFloat){
    
        DispatchQueue.main.async {
         
           self.shapeLayer?.strokeEnd = progress
            
        }
    }
    
}
