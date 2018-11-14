//
//  HighlightView.swift
//  Highlight
//
//  Created by nam yeon hun on 13/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class HighlightView : UIView{
    
    let label : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        
        label.layer.masksToBounds = true
        label.layer.backgroundColor = UIColor.white.cgColor
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var attributedText : NSMutableAttributedString?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        self.addSubview(backView)
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(highlight : HighlightModel) {
        self.attributedText = NSMutableAttributedString(string: highlight.str,
                                                        attributes: [.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)])
        self.label.frame = CGRect(x: 16, y: highlight.rect.minY, width: highlight.rect.width, height: highlight.rect.height)
        self.backView.frame = CGRect(x: 0, y: highlight.rect.minY, width: UIScreen.main.bounds.width, height: highlight.rect.height)
        self.label.attributedText = self.attributedText
    }
}
