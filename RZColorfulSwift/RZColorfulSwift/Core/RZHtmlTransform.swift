//
//  RZHtmlTransform.swift
//  RZColorfulSwift
//
//  Created by rztime on 2020/9/17.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

/// 需要将富文本属性转换为web的html的辅助类
/// 因为系统转换方法，不支持部分标签（删除线、下划线、斜体、扩展、描边、书写方向等），所以其本质是将部分不支持的标签，通过转为css来支持，
public class RZHtmlTransform {
    public typealias RZStyleConfigure = ((_ obj: Any, _ attr: NSDictionary) -> String)
    // 属性回调
    public var styleConfigure: RZStyleConfigure?
    // 单个属性
    public var key: NSAttributedString.Key?
    // 多个属性组合
    public var keys: [NSAttributedString.Key] = []
    
    /// 原富文本中，本身包含的url（这个转换，其实就是给每一个文段加一个<a标签，然后写入style，没有href，所以不会有链接的实际效果）
    public var url: String?
    // 要添加的style
    public var style: String?
    /// 初始化，单个需要处理的属性
    init(key: NSAttributedString.Key? = nil, styleConfigure: RZStyleConfigure? = nil) {
        self.key = key
        self.styleConfigure = styleConfigure
    }
    /// 初始化，需要组合的属性
    init(keys: [NSAttributedString.Key]?, styleConfigure: RZStyleConfigure?) {
        self.keys = keys ?? []
        self.styleConfigure = styleConfigure
    }
    /// iOS 不支持的标签，需要转换为web标签的配置 可以通过单例添加，将按照数组顺序执行，优先级高的在前
    public lazy var webLabels: [RZHtmlTransform] = {
        return [
            /// 删除线  下划线 组合到一起  下划线和删除线 不支持单独设置颜色
            RZHtmlTransform.init(keys: [.strikethroughStyle, .underlineStyle]) { (vale, attrs) -> String in
                var color: UIColor? = attrs[NSAttributedString.Key.strikethroughColor] as? UIColor
                if color == nil {
                    color = attrs[NSAttributedString.Key.underlineColor] as? UIColor
                }
                if color == nil {
                    color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor
                }
                var colorString = ""
                if let color = color {
                    colorString = "\(color.rz_hexString())"
                }
                return "text-decoration: line-through underline; text-decoration-color: \(colorString);"
            },
            /// 斜体, 扩张 组合到一起
            RZHtmlTransform.init(keys: [.obliqueness, .expansion]) { (value, attrs) -> String in
                var i: Float = 0
                if let it = attrs[NSAttributedString.Key.obliqueness] as? NSNumber {
                    i = it.floatValue
                }
                var e: Float = 0
                if let et = attrs[NSAttributedString.Key.expansion] as? NSNumber {
                    e = et.floatValue
                }
                let itemp = RZHtmlTransform.italicTrans(i)
                let etemp = RZHtmlTransform.expansionTrans(e)
                return "transform:skew(\(itemp)deg) scaleX(\(etemp));transform-origin: 0 0; display:inline-block;"
            },
            /// 描边
            RZHtmlTransform.init(keys: [.strokeWidth, .strokeColor], styleConfigure: { (value, attrs) -> String in
                var v: CGFloat = CGFloat((attrs[NSAttributedString.Key.strokeWidth] as? NSNumber)?.floatValue ?? 0) 
                var font: UIFont = (attrs[NSAttributedString.Key.font] as? UIFont) ?? .systemFont(ofSize: 1)
                var color = attrs[NSAttributedString.Key.strokeColor] as? UIColor
                var colorString = ""
                if let c = color  {
                    colorString = "\(c.rz_hexString())"
                }
                if v <= 0 {
                    return "-webkit-text-stroke: \(-v * (font.pointSize / 100.0))px \(colorString);"
                }
                // 大于0时，是中空，用透明色来模拟
                return "-webkit-text-stroke: \(v * (font.pointSize / 100.0))px \(colorString); color:#00000000;"
            }),
            /// 背景色
            RZHtmlTransform.init(key: .backgroundColor, styleConfigure: { (value, dict) -> String in
                if let color = value as? UIColor {
                    return "background-color: \(color.rz_hexString());"
                }
                return ""
            }),
            /// 删除线
            RZHtmlTransform.init(key: .strikethroughStyle, styleConfigure: { (value, attrs) -> String in
                var color = attrs[NSAttributedString.Key.strikethroughColor] as? UIColor
                if color == nil {
                    color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor
                }
                var colorString = ""
                if let c = color {
                    colorString = "\(c.rz_hexString())"
                }
                return "text-decoration: line-through; text-decoration-color: \(colorString);"
            }),
            /// 下划线
            RZHtmlTransform.init(key: .underlineStyle, styleConfigure: { (value, attrs) -> String in
                var color = attrs[NSAttributedString.Key.underlineColor] as? UIColor
                if color == nil {
                    color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor
                }
                var colorString = ""
                if let c = color {
                    colorString = "\(c.rz_hexString())"
                }
                return "text-decoration: underline; text-decoration-color: \(colorString);"
            }),
            /// 描边
            RZHtmlTransform.init(key: .strokeWidth, styleConfigure: { (value, attrs) -> String in
                var v: CGFloat = CGFloat((value as? NSNumber)?.floatValue ?? 0)
                var font: UIFont = (attrs[NSAttributedString.Key.font] as? UIFont) ?? .systemFont(ofSize: 1)
                var color = attrs[NSAttributedString.Key.strokeColor] as? UIColor
                var colorString = ""
                if let c = color  {
                    colorString = "\(c.rz_hexString())"
                }
                if v <= 0 {
                    return "-webkit-text-stroke: \(-v * (font.pointSize / 100.0))px \(colorString);"
                }
                // 大于0时，是中空，用透明色来模拟
                return "-webkit-text-stroke: \(v * (font.pointSize / 100.0))px \(colorString); color:#00000000;"
            }),
            /// 斜体
            RZHtmlTransform.init(key: .obliqueness, styleConfigure: { (value, attrs) -> String in
                let v = (value as? NSNumber)?.floatValue ?? 0
                let temp = RZHtmlTransform.italicTrans(v);
                return "transform:skew(\(temp)deg); transform-origin: 10 0; display:inline-block;";
            }),
            /// 扩张，即拉伸文字
            RZHtmlTransform.init(key: .expansion, styleConfigure: { (value, attrs) -> String in
                let v = (value as? NSNumber)?.floatValue ?? 0
                let temp = RZHtmlTransform.expansionTrans(v);
                return "transform:scaleX(\(temp)); transform-origin: 0 0; display:inline-block;";
            }),
            /// 书写方向
            RZHtmlTransform.init(key: .writingDirection, styleConfigure: { (value, attrs) -> String in
                let value: [Int] = value as? [Int] ?? [0]
                let dir = RZHtmlTransform.directionTrans(value.first ?? 0)
                switch dir {
                case .LRE:
                    return "direction: ltr; unicode-bidi: embed"
                case .LRO:
                    return "direction: ltr; unicode-bidi: bidi-override"
                case .RLE:
                    return "direction: rtl; unicode-bidi: embed"
                case .RLO:
                    return "direction: rtl; unicode-bidi: bidi-override"
                }
            }),
        ]
    }()
}
public extension RZHtmlTransform {
    /// 单例
    static let share = RZHtmlTransform.init()
    

    /// 将url和style合并，成为新的url，将写入到html的href中
    func mergeUrlAndStyle() -> String? {
        var text = ""
        if let u = url, u.count > 0 {
            text = text.appending(u)
        }
        if let s = style, s.count > 0 {
            text = text.appending(s)
        }
        return text
    }
    /// 将mergeUrlAndStyle过的url还原
    func creatHtmlLabelWith(html: String?) -> String? {
        var h = html ?? ""
        let mr = self.mergeUrlAndStyle()
        if let m = mr, m.count > 0 {
            let href = "href=\"\(m)\""
            var u = ""
            if let url = self.url, url.count > 0 {
                u = "href=\"\(url)\""
            }
            var s = ""
            if let style = self.style, style.count > 0 {
                s = " style=\"\(style)\""
            }
            h = h.replacingOccurrences(of: href, with: "\(u)\(s)")
        }
        return h
    }
    /// 将iOS系统的斜体转换为web对应的角度
    static func italicTrans(_ value: Float) -> Float {
        var temp = atanf(fabsf(value)) * Float(180.0) / Float(Double.pi)
        if value > 0 {
            temp = -temp
        }
        return temp
    }
    /// 将iOS系统的扩展倍数转换为web对应的倍数 官方的拉伸压缩比例，暂未找到资料，下边的数据，仅做相似参考，如果你知道，请反馈给我吧，谢谢
    static func expansionTrans(_ value: Float) -> Float {
        let v = value
        var temp = v
        if v < -1 {
            temp = -1 / (v * 2 * v + 1)
        } else if v < 0 {
            temp = v / 1.5 + 1
        } else if v <= 1 {
            temp = v * 1.5 + 1
        } else if v > 1 {
            temp = v * 2 * v + 1
        }
        return temp
    }
    /// 书写方向转换
    static func directionTrans(_ value: Int) -> RZTextAttribute.RZWriteDirection {
        switch value {
        case RZTextAttribute.RZWriteDirection.LRE.rawValue():
            return .LRE
        case RZTextAttribute.RZWriteDirection.LRO.rawValue():
            return .LRO
        case RZTextAttribute.RZWriteDirection.RLE.rawValue():
            return .RLE
        case RZTextAttribute.RZWriteDirection.RLO.rawValue():
            return .RLO
        default:
            return .LRO
        }
    }
}

public extension UIColor {
    func rz_hexString() -> String {
        guard let components = self.cgColor.components else {
            return ""
        }
        let r = lroundf(Float(components[0] * 255)).rz_16()
        let g = lroundf(Float(components[1] * 255)).rz_16()
        if components.count == 2 {
            return "#\(r)\(r)\(r)\(g)"
        }
        if components.count == 3 {
            let b = lroundf(Float(components[2] * 255)).rz_16()
            return "#\(r)\(g)\(b)"
        }
        if components.count == 4 {
            let b = lroundf(Float(components[2] * 255)).rz_16()
            let a = lroundf(Float(components[3] * 255)).rz_16()
            return "#\(r)\(g)\(b)\(a)"
        }
        return ""
    }
}
public extension Int {
    func rz_16() -> String {
        return NSString.init(format: "%02lX", self) as String
    }
}
