//
//  TestViewController.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/12.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view, typically from a nib.
        let scroview = UIScrollView.init(frame:self.view.bounds)
        self.view.addSubview(scroview)
        self.view.backgroundColor = UIColor.white
        
        self.title = "Results"
            
        var text = UITextView.init(frame: CGRect.init(x: 0, y: 10, width: self.view.bounds.size.width, height: 450))
        scroview.addSubview(text)
        scroview.contentSize = CGSize.init(width: 0, height: 1000)
        text.isEditable = false
        text.rz_colorfulConfer { (confer) in
//            confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(15).alignment(.center).and?.shadow?.shadowColor(.black).shadowOffset(.init(width: 3, height: 3)).shadowBlurRadius(3)
//            confer.paragraphStyle?.lineSpacing(20).and?.shadow?.shadowBlurRadius(3)
            confer.text("测试")?.textColor(.red).font(.systemFont(ofSize: 18)).paragraphStyle?.alignment(.right)
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
////            confer.imageByUrl("http://pic28.photophoto.cn/20130830/0005018667531249_b.jpg")?.paragraphStyle?.alignment(.center).and?.maxSize(CGSize.init(width: 100, height: 100)).size(.init(width: 130, height: 130)).shadow?.shadowColor(.black).shadowOffset(.init(width: 3, height: 3)).shadowBlurRadius(3)
            confer.imageByUrl("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1598590651104&di=58cd60b9b2754f3d5048fdf4bc74a081&imgtype=0&src=http%3A%2F%2Fa1.att.hudong.com%2F05%2F00%2F01300000194285122188000535877.jpg")?.paragraphStyle?.alignment(.right).and?.size(.init(width: 0, height: 100), align: .center)
////            confer.imageByUrl("http://pic28.photophoto.cn/20130830/0005018667531249_b.jpg")?.alignment(.center).maxSize(CGSize.init(width: 100, height: 100)).size(.init(width: 130, height: 130))
//            confer.text("连接啊啊啊啊啊111")?.tapAction("http:wwww.baidu.com").font(.systemFont(ofSize: 18)).underlineStyle(.single).underlineColor(.red)
//            confer.text("222连接啊啊啊啊啊")?.link(NSURL.init(string: "http:www.baidu.coccc.com")!).writingDirection(.RLO)
//
//            confer.text("\n")
//            confer.image(UIImage.init(named: "indexMore"))?.size(CGSize.init(width: 50, height: 50), align: .center, font: UIFont.systemFont(ofSize: 15)).tapAction("xkkkk.com")
//            confer.text("  图片居中对齐 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
        }
        text.delegate = self;
        text.rzDidTapTextView { (tabObj, textview) -> Bool in
            print("text:\(tabObj)")
            return false
        } 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("vc")
    }
}

extension TestViewController : UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("url:\(URL)")
        return false 
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("url:\(URL)")
        return false
    }
}
