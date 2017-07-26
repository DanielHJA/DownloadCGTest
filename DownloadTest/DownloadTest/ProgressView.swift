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
        shapeLayer?.lineWidth = 10.0
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.strokeColor = UIColor.green.cgColor
        shapeLayer?.lineCap = kCALineCapRound
        shapeLayer?.strokeStart = 0.0
        shapeLayer?.strokeEnd = 0.0
        
        let radius = self.frame.width * 0.2
        
        //let startAngle: CGFloat = CGFloat(3.0 * Double.pi / 4)
        //let endAngle: CGFloat = CGFloat(Double.pi / 4.0)
        
        let startAngle = CGFloat((Double.pi / 2) * 3)
        let endAngle = CGFloat(Double.pi * 2 + (Double.pi / 2) * 3)
        
        let circlePath = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius:radius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
        
        shapeLayer?.path = circlePath.cgPath
        
        self.layer.addSublayer(shapeLayer!)

    }
    
    func updateStroke(progress: CGFloat){
    
        DispatchQueue.main.async {
            
           self.shapeLayer?.strokeEnd = progress
            
        }
    }
    
}
