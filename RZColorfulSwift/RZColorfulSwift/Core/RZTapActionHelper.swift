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
    weak var rzTextView:UITextView? {
        didSet {
            self.tagert = self.rzTextView?.delegate
            self.rzTextView?.delegate = self
        }
    }
    weak var tagert : AnyObject? 
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textViewShouldBeginEditing)) {
                return tagert!.textViewShouldBeginEditing(textView)
            }
            return true
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textViewShouldEndEditing)) {
                return tagert!.textViewShouldEndEditing(textView)
            }
            return true
        }
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textViewDidBeginEditing)) {
                tagert!.textViewDidBeginEditing(textView)
            }
            return
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textViewDidBeginEditing)) {
                tagert!.textViewDidBeginEditing(textView)
            }
            return
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textView(_:shouldChangeTextIn:replacementText:))) {
                return tagert!.textView(textView, shouldChangeTextIn: range, replacementText: text)
            }
            return true
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textViewDidChange)) {
                tagert!.textViewDidChange(textView)
            }
            return
        }
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textViewDidChangeSelection)) {
                tagert!.textViewDidChangeSelection(textView)
            }
            return
        }
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let tapObj = URL.absoluteString
        let res1 = self.didTapActionWithId(tapObj: tapObj, textView: textView)
        var res2 = true 
        guard tagert == nil else {
            if tagert!.responds(to: (#selector(textView(_:shouldInteractWith:in:interaction:) as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool))){
                res2 = tagert!.textView(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction)
            }
            return res1 && res2
        }
        return res1 && res2
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textView(_:shouldInteractWith:in:interaction:)as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)){
                return tagert!.textView(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction)
            }
            return true
        }
        return true
    }
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let tapObj = URL.absoluteString
        let res1 = self.didTapActionWithId(tapObj: tapObj, textView: textView)
        var res2 = true
        guard tagert == nil else {
            if tagert!.responds(to: (#selector(textView(_:shouldInteractWith:in:) as (UITextView, URL, NSRange) -> Bool))){
                res2 = tagert!.textView(textView, shouldInteractWith: URL, in: characterRange)
            }
            return res1 && res2
        }
        return res1 && res2
    }
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        guard tagert == nil else {
            if tagert!.responds(to: #selector(textView(_:shouldInteractWith:in:)as (UITextView, NSTextAttachment, NSRange) -> Bool)){
                return tagert!.textView(textView, shouldInteractWith: textAttachment, in: characterRange)
            }
            return true
        }
        return true
    }
    
    func didTapActionWithId(tapObj:String?, textView:UITextView) -> Bool {
        if textView.rzDidTapTextView != nil {
            return textView.rzDidTapTextView!(tapObj ?? "", textView)
        }
        return true
    }
    
    deinit {
        rzTextView?.delegate = tagert as? UITextViewDelegate
    }
}
