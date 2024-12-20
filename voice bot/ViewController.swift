//
//  ViewController.swift
//  voice bot
//
//  Created by Gleb Korotkov on 20.12.2024.
//

import UIKit

class ViewController: UIViewController {
    private let recordManager = RecordManager()
    var isRecord: Bool = false
    private var originScale: CGAffineTransform = .identity
    private lazy var plusButton: UIButton = {
        $0.frame.size = CGSize(width: 70, height: 70)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .black
        $0.setImage(UIImage(systemName: "play"), for: .normal)
        $0.tintColor = .white
        $0.frame.origin = CGPoint(x: view.frame.width - 100, y: view.frame.height - 100)
        return $0
    }(UIButton(primaryAction: startAction))
    
    lazy var circleView: UIView = {
        $0.backgroundColor = .black
        $0.frame.size = CGSize(width: 100, height: 100)
        $0.center = view.center
        $0.layer.cornerRadius = 50
        originScale = $0.transform.scaledBy(x: 2, y: 2)
        return $0
    }(UIView())
    
    
    lazy var startAction: UIAction = UIAction{ [weak self ] _ in
        guard let self = self else {return }
        isRecord.toggle()
        if isRecord {
            recordManager.startRecording()
        } else{
            recordManager.stopRecording()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        view.addSubview(plusButton)
        view.addSubview(circleView)
        
        recordManager.voiceComplition = { [weak self] volume in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2) {
                let scaleFactor = CGFloat(0.5 - 1 / (volume / 2))
                self.circleView.transform = self.originScale.scaledBy(x: scaleFactor, y: scaleFactor)
            }
            
        }
    }
}
