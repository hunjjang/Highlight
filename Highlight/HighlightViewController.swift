//
//  HighlightViewController.swift
//  Highlight
//
//  Created by nam yeon hun on 14/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class HighlightViewController: UIViewController {
    
    var attributedText: NSMutableAttributedString
    
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        
        label.layer.masksToBounds = true
        label.layer.backgroundColor = UIColor.white.cgColor
        return label
    }()
    
    init(model : HighlightModel){
        self.attributedText = NSMutableAttributedString(string: model.str,
                                                        attributes: [.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)])
        self.label.attributedText = self.attributedText
        self.label.frame = model.rect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        //self.view.alpha = 0.1
        
        self.view.addSubview(self.label)
    }
}
