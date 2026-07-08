//
//  HtmlViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2026/7/3.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import RZColorfulSwift
import Kingfisher

class HtmlViewController: UIViewController {
    lazy var label = UILabel()
        .qthen {
            $0.qnumberOfLines(0).qtextColor(.black).qisUserInteractionEnabled(true).qbackgroundColor(.black.withAlphaComponent(0.05))
            /// 实现文本点击事件 
            $0.rz.tapAction { label, tapActionId, range in
                print("\(tapActionId)")
            }
        }
    lazy var textView = UITextView().qthen {
        $0.qisEditable(false).qisScrollEnabled(false).qcornerRadius(3, true).qbackgroundColor(.black.withAlphaComponent(0.05))
        $0.linkTextAttributes = [:]
        /// 实现文本点击事件
        $0.rz.tapAction({ sender, tapActionId, range in
            print("\(tapActionId)")
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            UIScrollView()
                .qmakeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                .qbody([
                    [
                        UILabel().qtext("UITextView").qfont(.systemFont(ofSize: 18)).qtextColor(.brown),
                        textView,
                        UILabel().qtext("UILabel").qfont(.systemFont(ofSize: 18)).qtextColor(.brown),
                        label
                    ].qjoined(aixs: .vertical, spacing: 20, align: .fill, distribution: .equalSpacing)
                        .qmakeConstraints({ make in
                            make.edges.equalToSuperview().inset(20)
                            make.width.equalTo(qscreenwidth - 40)
                        }),
                ])
        ])
        /// 需要注意，html里的字体，必须存在，否则无法正确计算
        textView.rz.colorfulConfer { confer in
            confer.htmlString(html)?.font(.systemFont(ofSize: 16))
        }
        label.rz.colorfulConfer { confer in
            confer.htmlString(html)?.font(.systemFont(ofSize: 16))
        }
    }
}
let html =
"""
<p style="color:red;">html内容html内容html内容html内容html内容html内容</p>
<p style="color:blue;">html内容html内容html内容html内容html内容html内容</p>
<p>html内容html内容html内容html内容html内容html内容</p>
<p>html内容html内容<a href="http://www.baidu.com">百度一下</a>html内容html内容html内容</p>
<p>html内容html内容html内容html内容html内容html内容</p>
<p>html内容html内容html内容html内容html内容html内容</p>
<p>html内容html内容html内容html内容html内容html内容</p>
"""
