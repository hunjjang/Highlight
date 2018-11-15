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
        
        self.attributedText = highlight.attributeText as? NSMutableAttributedString
            /*
            NSMutableAttributedString(string: highlight.str,
                                                        attributes: [.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)])
                                                                                                                                           */
        self.label = HighlightLabel(attributedText : self.attributedText!)
        self.addSubview(label!)
        
        self.label!.frame = CGRect(x: 16, y: highlight.rect.minY, width: highlight.rect.width, height: highlight.rect.height)
        self.backView.frame = CGRect(x: 0, y: highlight.rect.minY, width: UIScreen.main.bounds.width, height: highlight.rect.height)
        
    }
    
    func changeAttributeText(changedX: CGFloat , touchX : CGFloat) {
        
        if let layoutManager = self.label?.layoutManager {
            let index = layoutManager.characterIndex(for: CGPoint(x: changedX, y: 0), in: layoutManager.textContainers[0], fractionOfDistanceBetweenInsertionPoints: nil)
            
            if changedX > touchX {
                //Right
                self.attributedText?.addAttributes([.backgroundColor : UIColor.red], range: NSRange(location: index, length: 1))
            }else {
                //Left
                self.attributedText?.addAttributes([.backgroundColor : UIColor.white], range: NSRange(location: index, length: 1))
            }
            
            self.label?.attributedText = self.attributedText!
            self.changedAttribute(self.attributedText!)
        }
    }
}
