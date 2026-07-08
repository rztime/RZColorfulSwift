//
//  BaseUseViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2026/7/2.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import RZColorfulSwift
import Kingfisher
/// 基础用法
class BaseUseViewController: UIViewController {
    lazy var label = UILabel()
        .qthen {
            $0.qnumberOfLines(0).qtextColor(.black).qisUserInteractionEnabled(true).qbackgroundColor(.black.withAlphaComponent(0.05))
            // activeColorful会添加RZColorfulView，backgroundLayer、backgroundView以及clicked方法，会在这里边实现
            $0.activeColorful()
            /// 实现文本点击事件, 使用此方法时，可以不调用activeColorful，
            $0.rz.tapAction { label, tapActionId, range in
                print("\(tapActionId)")
            }
        }
    lazy var textView = UITextView().qthen {
        $0.qisEditable(false).qisScrollEnabled(false).qcornerRadius(3, true).qbackgroundColor(.black.withAlphaComponent(0.05))
        // activeColorful会添加RZColorfulView，backgroundLayer、backgroundView以及clicked方法，会在这里边实现
        $0.activeColorful()
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
        func tempAttr() -> NSAttributedString {
            let attr = NSAttributedString.rz.colorfulConfer { confer in
                /// 全局配置 paragraphStyle、shadow
                confer.paragraphStyle?.lineSpacing(5).paragraphSpacingBefore(5)
                confer.shadow?.shadowColor(.qhex("000000", a: 0.5)).shadowOffset(.init(width: 1, height: 1)).shadowBlurRadius(3)
                
                confer.text("可配置多种内容和属性:\n")?.font(.systemFont(ofSize: 16)).textColor(.black)
                confer.text("添加内容：text(文字)、image(图片)、imageByUrl(链接、本地图片路径)、htmlString()、view(添加自定义view),可直接在后面连接font、textColor等属性的配置，具体可看AttributeKeyRZ")?.font(.systemFont(ofSize: 16)).textColor(.black)
        
                confer.text("\n1: paragraphStyle\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("单独的段落样式：具体可以进入paragraphStyle查看")?.font(.systemFont(ofSize: 16)).textColor(.black).paragraphStyle?.lineSpacing(2)
                
                confer.text("\n2: shadow\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("单独的阴影样式：具体可以进入shadow查看")?.font(.systemFont(ofSize: 16)).textColor(.black).shadow?.shadowColor(.qhex("ff0000", a: 0.5)).shadowOffset(.init(width: 1, height: 1)).shadowBlurRadius(3)
                
                confer.text("\n3: shadow 和 paragraphStyle\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("单独的阴影、段落样式可用and连接")?.font(.systemFont(ofSize: 16)).textColor(.black).shadow?.shadowColor(.qhex("ff0000", a: 0.5)).shadowOffset(.init(width: 1, height: 1)).shadowBlurRadius(3).and?.paragraphStyle?.lineSpacing(2)
            
                confer.text("\n4: font textColor\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("字体的字号、颜色")?.font(.systemFont(ofSize: 16)).textColor(.brown)
                
                confer.text("\n5: backgroundColor\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("字体的背景色")?.font(.systemFont(ofSize: 16)).textColor(.black).backgroundColor(.lightGray)
                
                confer.text("\n6: strikethroughStyle strikethroughColor\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("删除线")?.font(.systemFont(ofSize: 16)).textColor(.black).strikethroughStyle(.styleSingle).strikethroughColor(.brown)
                
                confer.text("\n7: underlineStyle underlineColor\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("下划线")?.font(.systemFont(ofSize: 16)).textColor(.black).underlineStyle(.styleSingle).underlineColor(.brown)
                
                confer.text("\n8: strokeWidth strokeColor\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("描边(负值填充)")?.font(.systemFont(ofSize: 16)).textColor(.black).strokeWidth(-1).strokeColor(.brown)
                confer.text("    描边(正直中空)")?.font(.systemFont(ofSize: 16)).textColor(.black).strokeWidth(1).strokeColor(.brown)
                confer.text("    描边(3空心)")?.font(.systemFont(ofSize: 16)).textColor(.black).strokeWidth(3).strokeColor(.brown)
                
                confer.text("\n9: obliqueness\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("斜体")?.font(.systemFont(ofSize: 16)).textColor(.black).obliqueness(0.4)
                
                confer.text("\n10: kern\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("字间距")?.font(.systemFont(ofSize: 16)).textColor(.black).kern(10)
                
                confer.text("\n11: baselineOffset\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("上标")?.font(.systemFont(ofSize: 16)).textColor(.black)
                confer.text("2")?.font(.systemFont(ofSize: 11)).textColor(.black).baselineOffset(8)
                confer.text("、下标")?.font(.systemFont(ofSize: 16)).textColor(.black)
                confer.text("2")?.font(.systemFont(ofSize: 11)).textColor(.black).baselineOffset(-5)
                
                confer.text("\n12: expansion\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("拉伸(>0)    ")?.font(.systemFont(ofSize: 16)).textColor(.black).expansion(0.5)
                confer.text("压缩(<0)")?.font(.systemFont(ofSize: 16)).textColor(.black).expansion(-0.2)
                
                confer.text("\n13: link\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("百度一下，你就知道")?.font(.systemFont(ofSize: 16)).textColor(.blue).link(URL.init(string: "https://www.baidu.com"))
                
                confer.text("\n14 添加图片(两种方式)，以及对齐方式 image imageByUrl:\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.image(UIImage(named: "zan"))?.size(.init(width: 0, height: 30), align: .center, font: .systemFont(ofSize: 16)).tapAction("图片点击")
                confer.text("（居中）参考对齐文本\n")?.font(.systemFont(ofSize: 16)).textColor(.black)
                
                let path = Bundle.main.path(forResource: "Html.bundle/html_placeholder_gif", ofType: "gif")?.qtoURL
                confer.imageByUrl(path?.absoluteString)?.size(.init(width: 0, height: 40), align: .bottom, font: .systemFont(ofSize: 16)).clicked(clicked: { sender,range in
                    print("---图片点击")
                })
                confer.text("（居下）参考对齐文本")?.font(.systemFont(ofSize: 16)).textColor(.black)
                
                confer.text("\n15 添加自定义视图（如需gif，则可以自定义设置）view:\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.view(gifView())?.size(.init(width: 200, height: 100), align: .center, font: .systemFont(ofSize: 16))
                
                confer.text("\n16: backgroundView\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("给内容添加背景view, 多行的时候, 会有多个rects,frame即为文本所占的位置，包含了行间距，可以自行调整size，来调优显示")?.font(.systemFont(ofSize: 16)).textColor(.red).tapAction("点击背景").backgroundView { rects in
                    return rects.compactMap { rect -> UIView in
                        let view = UIView.init(frame: rect).qalpha(0.3).qbackgroundColor(.qhex("123456")).qcornerRadius(3, true)
                        view.frame.size.height = 21
                        /// 如果UIView.isUserInteractionEnabled = true, 则将不会触发tapAction，link，clicked等事件
                        view.qtap { view in
                            print("--- 点击背景")
                        }
                        return view
                    }
                }
                
                confer.text("\n17 将html转为富文本: htmlString\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.htmlString(#"<p style="color: green;font-size: 18px;">我区紧密型县域医共体建设取得阶段性成效…</p>"#)
                
                confer.text("\n18 添加文本可点击的功能: tapAction\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("<隐私政策>")?.font(.systemFont(ofSize: 16)).textColor(.blue).tapAction("<隐私政策>")
                confer.text("和")?.font(.systemFont(ofSize: 16)).textColor(.black)
                confer.text("<使用说明>")?.font(.systemFont(ofSize: 16)).textColor(.blue).tapAction("<使用说明>")
                
           
                confer.text("\n19 添加文本可点击的功能: clicked\n")?.font(.systemFont(ofSize: 16)).textColor(.red)
                confer.text("<隐私政策>")?.font(.systemFont(ofSize: 16)).textColor(.blue).clicked { sender, range in
                    print("---range: <隐私政策> \(range)")
                }
                confer.text("和")?.font(.systemFont(ofSize: 16)).textColor(.black)
                confer.text("<使用说明>")?.font(.systemFont(ofSize: 16)).textColor(.blue).clicked { sender, range in
                    print("---range: <使用说明> \(range)")
                }
            } ?? .init()
            return attr
        }
        // textView.attributedText = attr
        // label.attributedText = attr
        // 用tempAttr，是因为textView和label同时用attr，那么里边的view，会被争抢，所以这里测试代码，直接生成两份attr
        textView.attributedText = tempAttr()
        label.attributedText = tempAttr()
        // 也可以直接使用下面的方法
//        label.rz.colorfulConfer { confer in
//            confer.text("")
//        }
//        textView.rz.colorfulConfer { confer in
//            confer.text("")
//        }
    }
}
/// 还可以设置view的点击事件
@MainActor func gifView() -> UIView {
    let img = AnimatedImageView.init(frame: .init(x: 0, y: 0, width: 200, height: 100))
    let path = Bundle.main.path(forResource: "Html.bundle/html_placeholder_gif", ofType: "gif") ?? ""
    img.kf.setImage(with: path.qtoURL)
    img.qborder(.black, 1).qcornerRadius(0, true)
    img.qtap { view in
        print("-----点击图片")
    }
    return img
}
