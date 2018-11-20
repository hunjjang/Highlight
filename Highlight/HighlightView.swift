//
//  HighlightView.swift
//  Highlight
//
//  Created by nam yeon hun on 13/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class HighlightView : UIView{
    
    var label : HighlightLabel?
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var attributedText : NSMutableAttributedString?
    
    var changedAttribute = {(attribute: NSMutableAttributedString) -> Void in}
    
    var startLocation : Int?
    
    var endLocation : Int?
    
    var model : HighlightModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        self.addSubview(backView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(highlight : HighlightModel) {
        self.label?.removeFromSuperview()
        self.startLocation = nil
        self.endLocation = nil
        
        self.attributedText = highlight.attributeText as? NSMutableAttributedString
        
        self.label = HighlightLabel(attributedText : self.attributedText!)
        self.addSubview(label!)
        
        self.label!.frame = CGRect(x: 16, y: highlight.rect.minY, width: highlight.rect.width, height: highlight.rect.height)
        self.backView.frame = CGRect(x: 0, y: highlight.rect.minY, width: UIScreen.main.bounds.width, height: highlight.rect.height)
        
        self.model = highlight
    }
    
    func changeAttributeText(changedX: CGFloat) {
        
        if let layoutManager = self.label?.layoutManager {
            let index = layoutManager.characterIndex(for: CGPoint(x: changedX, y: 0), in: layoutManager.textContainers[0], fractionOfDistanceBetweenInsertionPoints: nil)
            
            self.model?.action(currentAttributeString: self.attributedText!, index: index, output: { attribute in
                self.attributedText = attribute
                self.label?.attributedText = self.attributedText!
                self.changedAttribute(self.attributedText!)
            })
        }
    }
}

