//
//  MDToHtmlViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2025/3/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import RZColorfulSwift
import QuicklySwift
class MDToHtmlViewController: UIViewController {
    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            webView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        let md = #"""
        ## 关于RZColorfulSwift
        * 对NSAttributeString的初始化做支持
        * 支持UILabel、UITextView、UITextField的attributedText的设置。
        * 包含的属性快捷设置：
            * 段落样式
            * 阴影
            * 文本字体、颜色
            * 文本所在区域对应的背景颜色
            * 连体字
            * 字间距
            * 删除线、下划线，及其线条颜色
            * 描边，及其颜色
            * 斜体字
            * 拉伸
            * 通过html源码加载富文本
            * 通过url添加图片到富文本
            * 等等
        ## How to use
        ```
        use_frameworks!

        pod 'RZColorfulSwift'
        ```
        * 主要的功能：
            * AttributeCore
                * ColorfulConferrerRZ.swift                         富文本中对文字、图片、段落、阴影、网页源码等归纳集合
                * AttributeKeyRZ.siwft                              富文本内可以设置的所有的方法（NSAttributedString.key）
                * TextAttributeRZ.swift                             文字 继承于AttributeKeyRZ
                * ImageAttributeRZ.swift                            图片 继承于AttributeKeyRZ
                * ParagraphStyleRZ.swift                            对段落样式的一个属性方法集合
                * ShadowStyleRZ.swift                               对阴影样式的一个属性方法集合
            * Core 对UILabel、UITextView、UITextField添加的富文本快捷写入提供入口
                * NSAttributedString                                富文本的方法
                * UILabel
                * UITextView
                * UITextField
        可以覆盖原文本、追加、以及指定位置插入等功能
            
        ### 基本的简单使用方法与OC版本差不多 [查看详细用法](https://github.com/rztime/RZColorful)
        ```swift
        text.rz.colorfulConfer { (confer) in
            confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(15)

            confer.image(UIImage.init(named: "indexMore"))?.bounds(CGRect.init(x: 0, y: 0, width: 20, height: 20))
            confer.text("  姓名 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
            confer.text("rztime")?.font(UIFont.systemFont(ofSize: 15)).textColor(.black)
        }

        ```
        """#
        let html = MarkDownRZ.parse(md)?.mdcss
        /// 解析md后的html，没有任何的样式，需要自行组装head里style：颜色、字号、列表、代码等等）
        webView.loadHTMLString(html ?? "", baseURL: nil)
    }
}
extension String {
    var mdcss: String {
        return """
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta http-equiv="Content-Style-Type" content="text/css">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-size: 16px; /* 16号字体 */
            }
            table {
                border-collapse: collapse; /* 合并边框 */
                border: 1px solid #dddddd; /* 表格边框颜色和宽度 */
            }
    /* 为单元格设置边框颜色 */
            th, td {
                border: 1px solid #dddddd; /* 单元格边框颜色和宽度 */
                padding: 8px; /* 单元格内边距 */
                text-align: left; /* 文本居中 */
            }
            /* 块级代码样式 */
            pre {
                background-color: #f8f8f8; /* 浅灰色背景 */
                padding: 10px; /* 内边距 */
                border-radius: 5px; /* 圆角边框 */
                border: 1px solid #ddd; /* 浅灰色边框 */
                overflow-x: auto; /* 水平滚动条 */
                white-space: pre-wrap; /* 自动换行 */
            }
        </style>
    </head>
    <body>
        \(self)
    </body>
</html>
"""
    }
}
