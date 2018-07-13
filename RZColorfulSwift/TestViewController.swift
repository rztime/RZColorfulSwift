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

        let text = UITextView.init(frame: CGRect.init(x: 0, y: 10, width: self.view.bounds.size.width, height: 450))
        scroview.addSubview(text)
        scroview.contentSize = CGSize.init(width: 0, height: 1000)
        text.isEditable = false
        text.rz_colorfulConfer { (confer) in
            confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(15)
            
            confer.image(UIImage.init(named: "indexMore"))?.bounds(CGRect.init(x: 0, y: 0, width: 20, height: 20))
            confer.text("  姓名 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
            confer.text("rztime")?.font(UIFont.systemFont(ofSize: 15)).textColor(.black)
            
            confer.text("\n")
            confer.text("location : ")?.font(UIFont.systemFont(ofSize: 11)).textColor(.gray)
            confer.text("成都软件园")?.font(UIFont.systemFont(ofSize: 11)).textColor(.black)
            
            confer.text("\n\n\n\n")
            confer.imageByUrl("http://pic28.photophoto.cn/20130830/0005018667531249_b.jpg")?.alignment(.center).maxSize(CGSize.init(width: 100, height: 100))
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("testVc 销毁")
    }

}
