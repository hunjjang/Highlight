//
//  ViewController.swift
//  Highlight
//
//  Created by nam yeon hun on 13/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var locationFromTextView: CGPoint?
    
    var selectRange: NSRange?
    
    let attributedString = NSMutableAttributedString(string: "Here is what the Documentation looks like :Returns the index of the character falling under the given point,expressed in the given container's coordinate system.If no character is under the point, the nearest character is returned,where nearest is defined according to the requirements of selection by touch or mouse.This is not simply equivalent to taking the result of the correspondingglyph index method and converting it to a character index, because in somecases a single glyph represents more than one selectable character, for example an fi ligature glyph.In that case, there will be an insertion point within the glyphand this method will return one character or the other, depending on whether the specifiedpoint lies to the left or the right of that insertion point.In general, this method will return only character indexes for which thereis an insertion point (see next method).  The partial fraction is a fraction of the distancefrom the insertion point logically before the given character to the next one,which may be either to the right or to the left depending on directionality."
    )
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = false
        
        tv.textContainer.lineFragmentPadding = 0
        tv.textContainerInset = .zero
        return tv
    }()
    
    let dotView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let highlightView: HighlightView = {
        let view = HighlightView()
        view.isHidden = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.attributedString.addAttributes([.font : UIFont.systemFont(ofSize: 17,weight: UIFont.Weight.medium),.backgroundColor : UIColor.white],
                                            range: NSRange(location: 0, length: self.attributedString.string.count))
        
        self.textView.attributedText = attributedString
        
        let longGesture = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(logPressTextView(_:)))
        self.textView.addGestureRecognizer(longGesture)
        
        self.view.addSubview(textView)
        self.view.addSubview(highlightView)
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
        
        self.highlightView.frame = self.view.frame
    }
    
    @objc private func logPressTextView(_ longGesture: UILongPressGestureRecognizer) {
         let locationFromTextView = longGesture.location(in: self.textView)
        
        switch longGesture.state{
        case .ended:
            self.highlightView.isHidden = true
        
        case .began:
            self.locationFromTextView = locationFromTextView
            
            var highlightModel: HighlightModel?
            
            let glyphIndex = self.textView.layoutManager.glyphIndex(for: self.locationFromTextView!,
                                                                    in: self.textView.textContainer)
            
            let rect = self.textView.layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1),
                                                                in: self.textView.textContainer)

            let glyphRange = self.textView.layoutManager.glyphRange(forBoundingRect: rect,
                                                                    in: self.textView.textContainer)
            
            highlightModel = HighlightModel(rect : CGRect(x: 0,
                                                          y: rect.minY + self.view.safeAreaInsets.top,
                                                          width: self.textView.frame.width,
                                                          height: rect.height) ,
                                            attributeText:  self.textView.attributedText.attributedSubstring(from: glyphRange))
            
            self.selectRange = glyphRange
     
            self.highlightView.changedAttribute = { changedAttributeString in

                self.attributedString.deleteCharacters(in: self.selectRange!)
                self.attributedString.insert(changedAttributeString, at: self.selectRange!.location)
                
                self.textView.attributedText = self.attributedString
            }
            
            if let highlightModel = highlightModel {
                self.highlightView.configure(highlight: highlightModel)
            }
            
        case .changed:
            self.highlightView.isHidden = false
            self.highlightView.changeAttributeText(changedX: locationFromTextView.x)
            
        default:
            break
        }
    }
}

