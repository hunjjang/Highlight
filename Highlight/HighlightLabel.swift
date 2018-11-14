//
//  HighlightLabel.swift
//  Highlight
//
//  Created by nam yeon hun on 15/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class HighlightLabel: UILabel {
    
    var layoutManager: NSLayoutManager?
    var textStorage: NSTextStorage?
    
    init(attributedText : NSMutableAttributedString) {
        super.init(frame: .zero)
        self.attributedText = attributedText
        
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let attributedText = self.attributedText {
            self.textStorage = NSTextStorage(attributedString: attributedText)
        }
        
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 1
        
        self.layoutManager = NSLayoutManager()
        self.textStorage?.addLayoutManager(self.layoutManager!)
        self.layoutManager?.addTextContainer(textContainer)
        
        self.layoutManager?.textStorage = self.textStorage
    }
}
