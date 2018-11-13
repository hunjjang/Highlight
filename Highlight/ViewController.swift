//
//  ViewController.swift
//  Highlight
//
//  Created by nam yeon hun on 13/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let attributedString = NSMutableAttributedString(string: "Here is what the Documentation looks like :Returns the index of the character falling under the given point,expressed in the given container's coordinate system.If no character is under the point, the nearest character is returned,where nearest is defined according to the requirements of selection by touch or mouse.This is not simply equivalent to taking the result of the correspondingglyph index method and converting it to a character index, because in somecases a single glyph represents more than one selectable character, for example an fi ligature glyph.In that case, there will be an insertion point within the glyphand this method will return one character or the other, depending on whether the specifiedpoint lies to the left or the right of that insertion point.In general, this method will return only character indexes for which thereis an insertion point (see next method).  The partial fraction is a fraction of the distancefrom the insertion point logically before the given character to the next one,which may be either to the right or to the left depending on directionality."
    )
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(textView)
        textView.attributedText = attributedString
        self.view.setNeedsUpdateConstraints()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnTextView(_:)))
        self.textView.addGestureRecognizer(panGesture)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.textView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                             left: self.view.leftAnchor,
                             bottom: self.view.bottomAnchor,
                             right: self.view.rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 16,
                             paddingBottom: 16,
                             paddingRight: 16,
                             width: 0,
                             height: 0)
    }
    
    @objc private func panOnTextView(_ panGesture: UIPanGestureRecognizer) {
        let point = panGesture.location(in: self.textView)
        let velocity = panGesture.velocity(in: self.textView)
        self.highlightCharacter(point, velocity)
    }
    
    private func highlightCharacter(_ point :CGPoint, _ velocity : CGPoint) {
        if let textPosition = self.textView.closestPosition(to: point) {
            
            if let textRange = textView.tokenizer.rangeEnclosingPosition(textPosition,
                                                                         with: .character,
                                                                         inDirection: UITextDirection(rawValue: 1)){
                
                let location: Int = self.textView.offset(from: self.textView.beginningOfDocument, to: textRange.start)
                let length: Int = self.textView.offset(from: textRange.start, to: textRange.end)
                
                let range = NSRange(location: location, length: length)
                
                if velocity.x > 0 {
                    self.attributedString.addAttribute(.backgroundColor, value: UIColor.red, range: range)
                }else {
                    self.attributedString.addAttribute(.backgroundColor, value: UIColor.clear, range: range)
                }
                self.textView.attributedText = self.attributedString
            }
        }
    }
}

