//
//  TextLineModeViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2026/7/3.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import RZColorfulSwift
import Kingfisher

class TextLineModeViewController: UIViewController {
    let stackView = UIStackView.qjoined([], aixs: .vertical, spacing: 20, align: .fill, distribution: .equalSpacing)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            UIScrollView()
                .qmakeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                .qbody([
                    stackView
                        .qmakeConstraints({ make in
                            make.edges.equalToSuperview().inset(20)
                            make.width.equalTo(qscreenwidth - 40)
                        }),
                ])
        ])
        reload()
    }
    func reload() {
        /// demo为了方便，直接每次重新初始化，实际代码中不要这样写
        stackView.qremoveAllSubViews()
        stackView.qbody([
            /// 系统超行的情况下默认是"...", 这里可以自定义（文本、图片）都可以，
            UILabel().qthen {
                $0.rz.set(attributedString: displayText, maxLine: 3, maxWidth: qscreenwidth - 40, lineBreakMode: .byTruncatingTail, placeHolder: customText)
            },
            /// 显示折叠、展开，本质上就是判断了是否超行，然后替换这个customeText
            /// 超行显示收起或者显示全文，变的只是isFold
            /// 1.未超行的情况下，全部显示
            UILabel().qthen {
                $0.rz.set(attributedString: displayText, maxLine: 10, maxWidth: qscreenwidth - 40, isFold: isFold, showAllText: showAllText, showFoldText: foldtext)
                $0.rz.tapAction { [weak self] label, tapActionId, range in
                    if tapActionId == "...显示全文" {
                        isFold = false
                    } else if tapActionId == "收起" {
                        isFold = true
                    }
                    self?.reload()
                }
            },
            /// 2 超行的情况下，有展开和收起
            UILabel().qthen {
                $0.rz.set(attributedString: displayText, maxLine: 3, maxWidth: qscreenwidth - 40, isFold: isFold, showAllText: showAllText, showFoldText: foldtext)
                $0.rz.tapAction { [weak self] label, tapActionId, range in
                    if tapActionId == "...显示全文" {
                        isFold = false
                    } else if tapActionId == "收起" {
                        isFold = true
                    }
                    self?.reload()
                }
            },
            /// 3 UITextView也支持，但宽度需要减去两侧的边距
            UITextView().qisEditable(false).qisScrollEnabled(false).qthen({
                let pad = $0.textContainerInset.left + $0.textContainerInset.right + 2 * $0.textContainer.lineFragmentPadding
                $0.rz.set(attributedString: displayText, maxLine: 3, maxWidth: qscreenwidth - 40 - pad, isFold: isFold, showAllText: showAllText, showFoldText: foldtext)
                $0.rz.tapAction({ [weak self] sender, tapActionId, range in
                    if tapActionId == "...显示全文" {
                        isFold = false
                    } else if tapActionId == "收起" {
                        isFold = true
                    }
                    self?.reload()
                })
            }),
        ])
    }
    
}
var isFold = true
var showAllText = NSAttributedString.rz.colorfulConfer { confer in
    confer.text("...显示全文")?.font(.systemFont(ofSize: 17)).textColor(.red).tapAction("...显示全文")
}
var foldtext = NSAttributedString.rz.colorfulConfer { confer in
    confer.text("收起")?.font(.systemFont(ofSize: 17)).textColor(.red).tapAction("收起")
}
var customText = NSAttributedString.rz.colorfulConfer { confer in
    /// 截断时，填充内容, 可以是图片、文本、view等等
    confer.text("---")?.font(.systemFont(ofSize: 17)).textColor(.green)
    confer.image(UIImage.init(named: "zan"))?.size(.init(width: 20, height: 20), align: .center, font: .systemFont(ofSize: 17))
}
var displayText = NSAttributedString.rz.colorfulConfer { confer in
    confer.text("展开或者折叠功能，需要设置maxLines，以及maxWidth，用于计算最终会显示多少行，如果行数未超过，则直接完全显示，如果行数超过了，则根据isFold属性，判断是展开是还是折叠")?.font(.systemFont(ofSize: 17)).textColor(.black)
}
