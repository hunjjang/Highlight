//
//  HighlightModel.swift
//  Highlight
//
//  Created by nam yeon hun on 14/11/2018.
//  Copyright © 2018 nam yeon hun. All rights reserved.
//

import UIKit

class HighlightModel {
    let attributeText: NSAttributedString
    let rect: CGRect
    let textCount: Int
    
    var cancelIndexList = [Int]()
    
    var highlightIndexList = [Int]()
    
    var lastIndex: Int?
    
    var isLeft = false
    
    var lowestIndex : Int?
    var highestIndex : Int?
    
    init(rect: CGRect , attributeText: NSAttributedString) {
        self.rect = rect
        self.attributeText = attributeText
        self.textCount = attributeText.string.count
    }
    
    func action(currentAttributeString: NSMutableAttributedString,
                         index: Int,
                         output : (NSMutableAttributedString) -> Void) {
        
        if let lastIndex = self.lastIndex {
            
            if lastIndex > index {
                // Left
                if highlightIndexList.count != 0 {
                    self.highlightIndexList = self.highlightIndexList.sorted {return $0 < $1}
                    self.cancelIndexList.append(self.highlightIndexList.last!)
                }
                
                self.highlightIndexList = []
                self.cancelIndexList.append(index)
                self.cancelAction(currentAttirbuteString: currentAttributeString) { (cancelAttribute) in
                    self.lastIndex = index

                    output(cancelAttribute)
                }
            }else if lastIndex < index {
                // Right
                self.cancelIndexList = []
                self.highlightIndexList.append(index)
                self.highlightAction(currentAttributeString: currentAttributeString) { (highlightAttribute) in
                    self.lastIndex = index
                    
                    output(highlightAttribute)
                }
            }else {

                self.lastIndex = index
                self.highlightIndexList.append(index)
                self.cancelIndexList.append(index)
            }
        }else {
            self.lastIndex = index
            self.highlightIndexList.append(index)
            self.cancelIndexList.append(index)
        }
    }
    
    func highlightAction (currentAttributeString: NSMutableAttributedString,
                          output: (NSMutableAttributedString ) -> Void) {
        
        self.highlightIndexList = self.highlightIndexList.sorted {return $0 < $1}
        if let firstIndex = self.highlightIndexList.first, let lastIndex = self.highlightIndexList.last {
            
            if lowestIndex == nil {
                self.lowestIndex = firstIndex
            }else {
                if self.lowestIndex! > firstIndex {
                    self.lowestIndex = firstIndex
                }
            }
            
            let length = lastIndex - self.lowestIndex!
            
            currentAttributeString.addAttribute(.backgroundColor,
                                                value: UIColor.yellow,
                                                range: NSRange(location: self.lowestIndex! , length: length + 1))
        }

        output(currentAttributeString)
    }

    func cancelAction (currentAttirbuteString: NSMutableAttributedString,
                       output : (NSMutableAttributedString) -> Void) {
        
        self.cancelIndexList = self.cancelIndexList.sorted {return $0 < $1}
        if let firstIndex = self.cancelIndexList.first, let lastIndex = self.cancelIndexList.last {
            
            if highestIndex == nil {
                self.highestIndex = lastIndex
            }else {
                if self.highestIndex! < lastIndex {
                    self.highestIndex = lastIndex
                }
            }
            
            let length = self.highestIndex! - firstIndex
            
            currentAttirbuteString.addAttribute(.backgroundColor,
                                                value: UIColor.white,
                                                range: NSRange(location: firstIndex, length: length + 1))
        }

        output(currentAttirbuteString)
    }
}
