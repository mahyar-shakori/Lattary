//
//  ViewController.swift
//  Lattary
//
//  Created by Mahyar on 2/20/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var wheelView: WheelView!
    var cursorView: CursorView!
    var playerName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupWheel() {
        wheelView = WheelView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        wheelView.names = playerName
        wheelView.center = view.center
        view.addSubview(wheelView)
    }
    
    func setupCursor() {
        let cursorSize = CGSize(width: 30, height: 30)
        cursorView = CursorView(frame: CGRect(x: wheelView.center.x - cursorSize.width / 2, y: wheelView.frame.minY - cursorSize.height, width: cursorSize.width, height: cursorSize.height))
        self.view.addSubview(cursorView)
    }
    
    @IBAction func spinButton(_ sender: Any) {
        wheelView.spin()
    }
    
    @IBAction func addPlayerButtonTapped(_ sender: Any) {
        playerName.append(nameTextField.text ?? "")
        setupWheel()
        setupCursor()
    }
}

class WheelView: UIView {
    var names: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let numSegments = names.count
        let segmentAngle = (2 * CGFloat.pi) / CGFloat(numSegments)
        
        for (index, name) in names.enumerated() {
            let startAngle: CGFloat = segmentAngle * CGFloat(index)
            let endAngle: CGFloat = startAngle + segmentAngle
            
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: center)
            path.close()
            
            UIColor.random().setFill()
            path.fill()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
            
            let textPath = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            let textRect = CGRect(x: textPath.currentPoint.x, y: textPath.currentPoint.y, width: 100, height: 30)
            
            let textSize = name.size(withAttributes: attributes)
            let textPosition = CGPoint(x: center.x + (radius / 2 * cos(startAngle + (segmentAngle / 2))) - (textSize.width / 2), y: center.y + (radius / 2 * sin(startAngle + (segmentAngle / 2))) - (textSize.height / 2))
            
            name.draw(at: textPosition, withAttributes: attributes)
        }
    }
    
    func spin() {
        let fullSpin = CGFloat.pi * 2
        let numberOfSpins = 4
        let randomAngle = CGFloat(arc4random_uniform(360) + 360)
        let totalRotation = fullSpin * CGFloat(numberOfSpins) + (randomAngle * CGFloat.pi / 180)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = totalRotation
        rotationAnimation.duration = 2
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

class CursorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.closePath()
        
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
