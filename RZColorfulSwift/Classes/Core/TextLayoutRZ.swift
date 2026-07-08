//
//  TextLayoutRZ.swift
//  RZColorfulSwift
//
//  Created by rztime on 2026/5/14.
//

import UIKit
public struct TextLineRZ {
    public let rect: CGRect
    public let range: NSRange
}
/// TextKit 富文本的布局计算
public class TextLayoutRZ {
    public var attributedString: NSMutableAttributedString = .init()
    public let textStorage: NSTextStorage
    public let layoutManager: NSLayoutManager
    public let textContainer: NSTextContainer
    
    /// - 注意： TextKit和UITextView一样, 当 lineBreakMode 不等于0和1时，那么每一段只能显示一行，此时计算的位置会出错
    public init(attributedText: NSAttributedString,
         size: CGSize,
         maximumNumberOfLines: Int = 0,
         lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        attributedString.setAttributedString(attributedText)
        textStorage = NSTextStorage(attributedString: attributedString)
        layoutManager = NSLayoutManager()
        textContainer = NSTextContainer(size: size)
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }
    /// UITextView时，可直接使用textView的
    public init(textView: UITextView) {
        attributedString.setAttributedString(textView.attributedText)
        textStorage = textView.textStorage
        layoutManager = textView.layoutManager
        textContainer = textView.textContainer
    }
    public func updateBy(_ label: UILabel) {
        self.updateAttributedString(label.attributedText)
        self.updateSize(label.bounds.size)
        self.updateNumberOfLines(label.numberOfLines)
    }
    public func updateLineFragmentPadding(_ padding: CGFloat) {
        if self.textContainer.lineFragmentPadding != padding {
            self.textContainer.lineFragmentPadding = padding
        }
    }
}
// MARK: - 更新配置
public extension TextLayoutRZ {
    func updateAttributedString(_ attr: NSAttributedString?) {
        let attr = attr ?? .init()
        if attr != attributedString {
            attributedString.setAttributedString(attr)
            textStorage.setAttributedString(attributedString)
        }
    }
    func updateSize(_ size: CGSize) {
        if self.textContainer.size != size {
            self.textContainer.size = size
        }
    }
    func updateNumberOfLines(_ numberOfLines: Int) {
        if self.textContainer.maximumNumberOfLines != numberOfLines {
            self.textContainer.maximumNumberOfLines = numberOfLines
        }
    }
}
public extension TextLayoutRZ {
    /// 文本实际位置
    func usedRect() -> CGRect {
        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer)
    }
    /// 文本总区域位置
    func textBoundsRect() -> CGRect {
        layoutManager.ensureLayout(for: textContainer)
        let r = layoutManager.glyphRange(for: textContainer)
        return layoutManager.boundingRect(forGlyphRange: r, in: textContainer)
    }
    /// range字符位置（如果跨行，则是完全包围的位置）
    func rect(for characterRange: NSRange) -> CGRect {
        layoutManager.ensureLayout(for: textContainer)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    /// index对应的文本的位置
    func rect(forCharacterAt index: Int) -> CGRect {
        layoutManager.ensureLayout(for: textContainer)
        let glyphRange = NSRange(location: index, length: 1)
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    /// range（跨行）的实际位置
    func rects(for range: NSRange) -> [CGRect] {
        layoutManager.ensureLayout(for: textContainer)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        var rects: [CGRect] = []
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { _, usedRect, _, lineGlyphRange, _ in
            let intersection = NSIntersectionRange(lineGlyphRange, glyphRange)
            if intersection.length > 0 {
                let rect = self.layoutManager.boundingRect(forGlyphRange: intersection, in: self.textContainer)
                rects.append(rect)
            }
        }
        return rects
    }
    /// point位置对应的文本的index (NSRange.location)
    func characterIndex(at point: CGPoint) -> Int? {
        layoutManager.ensureLayout(for: textContainer)
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        guard index < textStorage.length else { return nil }
        let rect = self.rect(forCharacterAt: index)
        return rect.contains(point) ? index : nil
    }
}
public extension TextLayoutRZ {
    /// maxLines行时，内容长度
    /// 需注意最后一个字符为"\n"的情况
    /// 因为这里计算的是maxLines时，textContainer包含的所有的字符串，那么\n也将被包含
    /// 如：
    /// 123\n
    /// 456\n
    /// 789\n
    /// 那么3行的情况下，这里的所有的内容都将被包含在textContainer中，返回的length=12包含了最后的"\n",这样的结果会导致实际显示的是4行
    /// 解决方案是判断最后一个为\n时，在后面随机加一个字符串
    func lengthBy(_ maxLines: Int) -> Int {
        self.updateNumberOfLines(maxLines)
        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.glyphRange(for: textContainer).length
    }
    /// 是否超过行数
    func moreThanLines(_ maxLines: Int) -> Bool {
        return layoutManager.numberOfGlyphs > self.lengthBy(maxLines)
    }
    /// 总行数
    func numberOfLines() -> Int {
        layoutManager.ensureLayout(for: textContainer)
        var count = 0
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { _, _, _, _, _ in
            count += 1
        }
        return count
    }
    /// 每一行的信息
    func lineFragments() -> [TextLineRZ] {
        layoutManager.ensureLayout(for: textContainer)
        var result: [TextLineRZ] = []
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { rect, _, _, range, _ in
            let charRange = self.layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: nil)
            result.append(TextLineRZ(rect: rect, range: charRange))
        }
        return result
    }
}
