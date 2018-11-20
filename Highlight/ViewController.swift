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
        tv.isSelectable = false
        
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    let backView: HighlightView = {
        let view = HighlightView()
        view.isHidden = true
        
        return view
    }()
    
    var locationFromTextView: CGPoint?
    
    var selectRange: NSRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.attributedString.addAttributes([.font : UIFont.systemFont(ofSize: 17,weight: UIFont.Weight.medium),
                                             .backgroundColor : UIColor.white], range: NSRange(location: 0, length: self.attributedString.string.count))
        
        self.textView.attributedText = attributedString
        
        let longGesture = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(logPressTextView(_:)))
        self.textView.addGestureRecognizer(longGesture)
        
        self.view.addSubview(textView)
        self.view.addSubview(backView)
        self.view.setNeedsUpdateConstraints()
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
        
        self.backView.frame = self.view.frame
    }
    
    @objc private func logPressTextView(_ longGesture: UILongPressGestureRecognizer) {
        let locationFromTextView = longGesture.location(in: self.textView)
        
        switch longGesture.state{
        case .ended:
            self.backView.isHidden = true
            self.backView.changedAttribute = { changedAttributeString in

                //let attribute = self.attributedString.attributedSubstring(from: self.selectRange!)
                self.attributedString.deleteCharacters(in: self.selectRange!)
                self.attributedString.insert(changedAttributeString, at: self.selectRange!.location)
                
                self.textView.attributedText = self.attributedString
                
            }
            
        case .began:
            self.locationFromTextView = locationFromTextView
            
            var highlightModel: HighlightModel?
            
            self.textView.layoutManager.enumerateLineFragments(forGlyphRange:
            NSRange(location: 0,length: textView.text.count)) {
                [weak self](rect, usedRect, textContainer, glyphRange, stop) in

                guard let self = self else {return}
                
                if (self.locationFromTextView?.y ?? 0) < usedRect.maxY {
                    let lineHeight = (self.textView.font?.lineHeight ?? 0 )
                    stop.assign(repeating: true, count:  Int((self.locationFromTextView?.y ?? 0) /  lineHeight) + 1)
                }
                
                //TextView 의 기본 패딩값 8,8,8,8rect
                highlightModel = HighlightModel(rect : CGRect(x: 0,
                                   y: usedRect.minY + self.view.safeAreaInsets.top + 8,
                                   width: usedRect.width,
                                   height: usedRect.height),
                                                attributeText:  self.textView.attributedText.attributedSubstring(from: glyphRange))
                
                self.selectRange = glyphRange
            }
            
            if let highlightModel = highlightModel {
                self.backView.configure(highlight: highlightModel)
                
            }
            
        case .changed:
            self.backView.isHidden = false
            self.backView.changeAttributeText(changedX: locationFromTextView.x)
            
        default:
            break
        }
    }
}


