//
//  TestViewController.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/12.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit
import RZColorfulSwift

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view, typically from a nib.
        let scroview = UIScrollView.init(frame:self.view.bounds)
        self.view.addSubview(scroview)
        self.view.backgroundColor = UIColor.white
        
        self.title = "Results"

//        let tempView = UIView.init(frame: .init(x: 100, y: 100, width: 100, height: 100))
//        self.view.addSubview(tempView)
//        tempView.rz.tap { (t) in
//            print("\(t)")
//        }
//        tempView.backgroundColor = .red
//        return
        
//        let label = UILabel.init(frame: self.view.bounds)
//        self.view.addSubview(label)
//        label.numberOfLines = 0
//        label.rz.colorfulConfer { (confer) in
//            confer.text("删除线 下划线")?.strikethroughStyle(.styleSingle).strikethroughColor(.black).textColor(.red).font(.systemFont(ofSize: 17)).underlineStyle(.styleSingle).underlineColor(.red)
//            confer.text("\n")
//            confer.text("斜体 扩展")?.obliqueness(1).textColor(.red).font(.systemFont(ofSize: 17)).expansion(1)
//            confer.text("\n")
//            confer.text("背景色")?.backgroundColor(.gray).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("描边")?.strokeWidth(1).strokeColor(.blue).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("下划线")?.textColor(.red).font(.systemFont(ofSize: 17)).underlineStyle(.styleSingle).underlineColor(.black)
//            confer.text("\n")
//            confer.text("删除线")?.strikethroughStyle(.styleSingle).strikethroughColor(.black).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("扩展")?.textColor(.red).font(.systemFont(ofSize: 17)).expansion(1)
//            confer.text("\n")
//            confer.text("斜体")?.obliqueness(1).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("连体fliafslkkkllll")?.ligature(1).textColor(.red).font(.systemFont(ofSize: 17))
//        }
//        label.rz.colorfulConferInsetTo(position: .End) { (confer) in
//            confer.text("\n22222222")?.ligature(1).textColor(.red).font(.systemFont(ofSize: 17))
//        }
//        return
        
        let text = UITextView.init(frame: CGRect.init(x: 0, y: 10, width: self.view.bounds.size.width, height: 450))
        scroview.addSubview(text)
        scroview.contentSize = CGSize.init(width: 0, height: 1000)
//        text.isEditable = false
        text.rz.colorfulConfer { (confer) in
            confer.paragraphStyle?.lineSpacing(20).paragraphSpacingBefore(15).alignment(.left).and?.shadow?.shadowColor(.black).shadowOffset(.init(width: 3, height: 3)).shadowBlurRadius(3)
            confer.text("哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈")
//            confer.paragraphStyle?.lineSpacing(20).and?.shadow?.shadowBlurRadius(3)
//            confer.text("测试\n")?.textColor(.red).font(.systemFont(ofSize: 18))
//            confer.htmlString("<p>测试文本</p><p>测试文本</p>")?.font(.systemFont(ofSize: 20)).textColor(.red)
//            confer.image(UIImage.init(named: "indexMore"))?.bounds(CGRect.init(x: 0, y: 0, width: 20, height: 20))
//            confer.text("  姓名 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
//            confer.text("rztime")?.font(UIFont.systemFont(ofSize: 15)).textColor(.black).shadow?.shadowBlurRadius(4).shadowOffset(.init(width: 4, height: 4)).shadowColor(.red).and?.backgroundColor(.green)
//
//            confer.text("\n")
//            confer.text("location : ")?.font(UIFont.systemFont(ofSize: 11)).textColor(.gray)
//            confer.text("成都软件园")?.font(UIFont.systemFont(ofSize: 11)).textColor(.black)
//
//            confer.text("\n\n\n\n")
//            confer.imageByUrl("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1598590651104&di=58cd60b9b2754f3d5048fdf4bc74a081&imgtype=0&src=http%3A%2F%2Fa1.att.hudong.com%2F05%2F00%2F01300000194285122188000535877.jpg")?.paragraphStyle?.alignment(.right).and?.size(.init(width: 0, height: 100), align: .center)
//            confer.imageByUrl("http://pic28.photophoto.cn/20130830/0005018667531249_b.jpg")?.paragraphStyle?.alignment(.center).and?.maxSize(CGSize.init(width: 100, height: 0), align: .center, font: .systemFont(ofSize: 18))
//            confer.text("连接啊啊啊啊啊111")?.tapAction("http:wwww.baidu.com").font(.systemFont(ofSize: 18)).underlineStyle(.single).underlineColor(.red)
//            confer.text("222连接啊啊啊啊啊")?.link(NSURL.init(string: "http:www.baidu.coccc.com")!)
//
//            confer.text("\n")
//            confer.image(UIImage.init(named: "indexMore"))?.size(CGSize.init(width: 50, height: 50), align: .center, font: UIFont.systemFont(ofSize: 15)).tapAction("xkkkk.com")
//            confer.text("  图片居中对齐 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
//            confer.htmlString("<span style=\"background-color: red;\"><s>&#x5475;&#x5475;&#x54C8;&#x54C8;&#x54C8;sssssss<u>dddddd</u></s><em>xxxxxxx</em><i>yyyyyyy</i></span>")
//            confer.text("删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线删除线 下划线")?.strikethroughStyle(.styleSingle).strikethroughColor(.black).textColor(.red).font(.systemFont(ofSize: 17)).underlineStyle(.styleSingle).underlineColor(.red)
//            confer.text("\n")
//            confer.text("斜体 扩展")?.obliqueness(1).textColor(.red).font(.systemFont(ofSize: 17)).expansion(1).paragraphStyle?.lineSpacing(10)
//            confer.text("\n")
//            confer.text("背景色")?.backgroundColor(.gray).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("描边")?.strokeWidth(1).strokeColor(.blue).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("下划线")?.textColor(.red).font(.systemFont(ofSize: 17)).underlineStyle(.styleSingle).underlineColor(.black)
//            confer.text("\n")
//            confer.text("删除线")?.strikethroughStyle(.styleSingle).strikethroughColor(.black).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("扩展")?.textColor(.red).font(.systemFont(ofSize: 17)).expansion(1)
//            confer.text("\n")
//            confer.text("斜体")?.obliqueness(1).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("连体fliafslkkkllll")?.ligature(1).textColor(.red).font(.systemFont(ofSize: 17))
//            confer.text("\n")
//            confer.text("点击的文本")?.tapAction("11111中文").font(.systemFont(ofSize: 15)).textColor(.blue)
//            if #available(iOS 15.0, *) {
//                confer.text("我也不知道这是啥")?.inlinePresentationIntent(.emphasized)
//            } else {
//                // Fallback on earlier versions
//            }
//            confer.paragraphStyle?.lineSpacing(40)
//            confer.text("自定义")?.custom(key: .rztap, value: "1111111")
        }
        text.delegate = self; 
//        text.rz.colorfulConfer { confer in
//            confer.text("哈哈哈哈\n")?.font(.systemFont(ofSize: 18)).textColor(.black)
//            confer.text("可点击文本1")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("1111").paragraphStyle?.alignment(.left)
//            confer.text("\n")
//            confer.text("可点击文本2")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("22222").paragraphStyle?.alignment(.center)
//            confer.text("\n")
//        }
//        text.rz.didTapTextView { (tabObj, textview) -> Bool in
//            print("text:\(tabObj)")
//            return false
//        }
//        let tt = text.attributedText.rz.codingToCompleteHtmlByWeb()?.removingPercentEncoding
        let tt = text.attributedText.rz.codingToCompleteHtml()
        print("\(tt ?? "")")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("11111")
    }
}

extension TestViewController : UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("url:\(URL.absoluteString.removingPercentEncoding ?? "")")
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("url:\(URL.absoluteString.removingPercentEncoding ?? "")")
        return false
    }
}
