//  FZDrawCouponsView.swift
//
//  Created by Jack on 2021/11/15.
//

import UIKit
import FZCommitKit

class FZDrawCouponsView: UIView {
    
    let dashLineWidth: CGFloat = 1.fit
    let lineFullLineWidth: CGFloat = 3.fit
    let lineSpeWidth: CGFloat = 1.fit
    
    let speDistance: CGFloat = 90.fit
    let speRadius: CGFloat = 10.fit
    let borderRadius: CGFloat = 5.fit
    
    let layerShadowColor = UIColor.gray.cgColor
    let shadowWidth: CGFloat = 2.fit

    let contentColor = UIColor.white.cgColor
    let lineColor = fz_hexStringColor(hexString: "#E0E0E0").cgColor
    let lineDistance: CGFloat = 10.fit
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCoupons()
    }
    
    private func drawCoupons() {
        let viewHeight: CGFloat = self.frame.size.height
        let viewWidth: CGFloat = self.frame.size.width
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: self.borderRadius, y: viewHeight))
        bezierPath.addLine(to: CGPoint(x: viewWidth-self.speDistance-self.speRadius, y: viewHeight))
        bezierPath.addArc(withCenter: CGPoint(x: viewWidth-self.speDistance, y: viewHeight), radius: self.speRadius, startAngle: -.pi, endAngle: 0, clockwise: true)
        bezierPath.addLine(to: CGPoint(x: viewWidth -  self.borderRadius, y: viewHeight))
        bezierPath.addArc(withCenter: CGPoint(x:viewWidth - self.borderRadius, y: viewHeight - self.borderRadius), radius: self.borderRadius, startAngle: .pi/2, endAngle: 0, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: viewWidth, y: self.borderRadius))
        bezierPath.addArc(withCenter: CGPoint(x: viewWidth - self.borderRadius, y: self.borderRadius), radius: self.borderRadius, startAngle: 0, endAngle: -(.pi/2), clockwise: false)
        bezierPath.addLine(to: CGPoint(x: viewWidth+self.speDistance, y: 0))
        bezierPath.addArc(withCenter: CGPoint(x: viewWidth-self.speDistance, y: 0), radius: self.speRadius, startAngle: 0, endAngle: .pi, clockwise: true)
        bezierPath.addLine(to: CGPoint(x: self.borderRadius, y: 0))
        bezierPath.addArc(withCenter: CGPoint(x: self.borderRadius, y: self.borderRadius), radius: self.borderRadius, startAngle: -(.pi/2), endAngle: -.pi, clockwise: false)
        bezierPath.addLine(to: CGPoint(x: 0, y: viewHeight - self.borderRadius))
        bezierPath.addArc(withCenter: CGPoint(x: self.borderRadius, y: viewHeight - self.borderRadius), radius: self.borderRadius, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        bezierPath.close()

        UIColor.clear.setFill()
        UIColor.clear.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        bezierPath.addClip()
        
        pathLayer.lineWidth = 3.fit
        pathLayer.fillColor = contentColor
        pathLayer.path = bezierPath.cgPath
        pathLayer.shadowColor = layerShadowColor
        pathLayer.shadowOffset = CGSize(width: 0, height: 0)
        pathLayer.shadowOpacity = 0.3
        pathLayer.shadowRadius = shadowWidth
        self.layer.addSublayer(pathLayer)

        /// 绘制虚线
        let dashX = viewWidth - self.speDistance
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: 1 + dashLineWidth, height: frame.size.height)
        shapeLayer.position = CGPoint(x: dashX, y: frame.size.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor
        shapeLayer.lineWidth = dashLineWidth
        shapeLayer.lineJoin = .round
        let l1 =  NSNumber(value: Double(lineFullLineWidth))
        let l2 = NSNumber(value: Double(lineSpeWidth))
        shapeLayer.lineDashPattern = [l1, l2]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0.5, y: borderRadius + lineDistance), transform: .identity)
        path.addLine(to: CGPoint(x: 0.5, y: frame.size.height - borderRadius - lineDistance), transform: .identity)
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
        
    }
    /// 防止重用时多次生成图层
    private let pathLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
