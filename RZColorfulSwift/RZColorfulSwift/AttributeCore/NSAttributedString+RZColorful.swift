//
//  NSAttributedString+RZColorful.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/10.
//  Copyright © 2018年 rztime. All rights reserved.
//

import Foundation

typealias ColorfulBlock = ((_ confer: RZColorfulConferrer) -> Void)

extension NSAttributedString {
    
    /// 富文本 归纳
    static func rz_colorfulConfer(confer:ColorfulBlock) -> NSAttributedString? {
        let connferrer = RZColorfulConferrer.init()
        confer(connferrer)
        return connferrer.confer();
    }
    
    static func htmlString(_ html: String?) ->NSAttributedString? {
        if html?.count == 0 || html == nil {
            return nil;
        }
        let data = html!.data(using: String.Encoding.unicode)
        do {
            return try NSAttributedString.init(data: data!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch let error as NSError {
            print("html转换失败:\(error.localizedDescription)")
        }
        return nil
    } 
}
