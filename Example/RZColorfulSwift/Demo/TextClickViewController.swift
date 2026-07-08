//
//  TextClickViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2026/7/3.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import RZColorfulSwift
import Kingfisher

class TextClickViewController: UIViewController {
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
                        UILabel().qfont(.systemFont(ofSize: 16)).qtextColor(.red).qnumberOfLines(0)
                            .qtext("rz.colorful的使用，UILabel和UITextView都是一样的方法"),
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
        let attr = NSAttributedString.rz.colorfulConfer { confer in
            confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(10)
            confer.text("1.文本点击事件: tapAction clicked\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("<隐私政策>")?.font(.systemFont(ofSize: 16)).textColor(.blue).tapAction("<隐私政策>")
            confer.text("和")?.font(.systemFont(ofSize: 16)).textColor(.black)
            confer.text("<使用说明>")?.font(.systemFont(ofSize: 16)).textColor(.blue).tapAction("<使用说明>")
            confer.text("和")?.font(.systemFont(ofSize: 16)).textColor(.black)
            confer.text("<用户协议>")?.font(.systemFont(ofSize: 16)).textColor(.blue).clicked { sender, range in
                print("---用户协议")
            }
      
            confer.text("\n2.图片点击: tapAction clicked\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.image(UIImage(named: "zan"))?.size(.init(width: 0, height: 30), align: .center, font: .systemFont(ofSize: 16)).tapAction("点击图片")
            confer.text("请点击图片\n")?.font(.systemFont(ofSize: 16)).textColor(.blue)

            confer.image(UIImage(named: "zan"))?.size(.init(width: 0, height: 30), align: .center, font: .systemFont(ofSize: 16)).clicked { sender, range in
                print("---点击图片")
            }
            confer.text("点击图片\n")?.font(.systemFont(ofSize: 16)).textColor(.blue)
        } ?? .init()
        textView.attributedText = attr
        label.attributedText = attr
// 或者
//        label.rz.colorfulConfer { confer in
//            confer.text("")
//        }
//        textView.rz.colorfulConfer { confer in
//            confer.text("")
//        }
    }
}
