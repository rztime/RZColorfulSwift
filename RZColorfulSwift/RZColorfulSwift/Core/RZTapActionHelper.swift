/*******************************************************************************
 # File        : RZTapActionHelper.swift
 # Project     : RZColorfulSwift
 # Author      : ruozui
 # Created     : 2020/2/25
 # Corporation : ****
 # Description :
 <#Description Logs#>
 *******************************************************************************/

import UIKit

public class RZTapActionHelper: NSObject , UITextViewDelegate {
    private weak var rzTextView:UITextView?
    private weak var tagert : UITextViewDelegate?
    
    public init(_ target:UITextView?) {
        super.init()
        self.rzTextView = target
        self.tagert = target?.delegate
        target?.delegate = self
    }
      
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return (tagert?.textViewShouldBeginEditing?(textView)) ?? true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return (tagert?.textViewShouldEndEditing?(textView)) ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        tagert?.textViewDidBeginEditing?(textView)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        tagert?.textViewDidBeginEditing?(textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (tagert?.textView?(textView, shouldChangeTextIn: range, replacementText: text)) ?? true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        tagert?.textViewDidChange?(textView)
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        tagert?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let tapObj = URL.absoluteString
        let res1 = self.didTapActionWithId(tapObj: tapObj, textView: textView)
        let res2 = (tagert?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction)) ?? true
        return res1 && res2
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return (tagert?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction)) ?? true
    }
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let tapObj = URL.absoluteString
        let res1 = self.didTapActionWithId(tapObj: tapObj, textView: textView)
        let res2 = (tagert?.textView?(textView, shouldInteractWith: URL, in: characterRange)) ?? true
        return res1 && res2
    }
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return (tagert?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange)) ?? true
    }
    private func didTapActionWithId(tapObj:String?, textView:UITextView) -> Bool {
        return (textView.rzDidTapTextView?(tapObj ?? "", textView)) ?? true
    }
    deinit { 
        rzTextView?.delegate = tagert
    }
}
