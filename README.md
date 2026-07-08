# RZColorfulSwift

[![CI Status](https://img.shields.io/travis/rztime/RZColorfulSwift.svg?style=flat)](https://travis-ci.org/rztime/RZColorfulSwift)
[![Version](https://img.shields.io/cocoapods/v/RZColorfulSwift.svg?style=flat)](https://cocoapods.org/pods/RZColorfulSwift)
[![License](https://img.shields.io/cocoapods/l/RZColorfulSwift.svg?style=flat)](https://cocoapods.org/pods/RZColorfulSwift)
[![Platform](https://img.shields.io/cocoapods/p/RZColorfulSwift.svg?style=flat)](https://cocoapods.org/pods/RZColorfulSwift)

iOS NSAttributedString 富文本方法 (图文混排、多样式文本); 
文本超行，可自动添加"折叠"、"全部"; 
markdown 转 html;
UILabel、UITextView的富文本支持添加自定义view、显示gif、给文本添加背景图、文本支持点击等功能

2.0.0版本后，富文本添加的点击功能更友好，富文本的布局计算更高效

## Installation

RZColorfulSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!

pod 'RZColorfulSwift'
```


## Author

rztime, rztime@vip.qq.com  QQ群：580839749

### Objc版本看这里[RZColorful](https://github.com/rztime/RZColorful)

## License

RZColorfulSwift is available under the MIT license. See the LICENSE file for more info.


### 更新日志
[更新日志](https://github.com/rztime/RZColorfulSwift/blob/master/UpdateLog.md)

UITextView实现的富文本编辑器[RZRichTextView](https://github.com/rztime/RZRichTextView)

* NSAttributedString 的多样化设置(文字字体、颜色、阴影、段落样式、url、下划线，以及图文混排、显示gif，backgroundView，文本点击等等)
* 添加UITextField、UITextView、UILabel的attributedText的富文本设置。


## 关于RZColorfulSwift
* 对NSAttributeString的初始化做支持
* 支持 markdown 文档转换为html
* 支持 HTML 与 NSAttributedString互换
* 支持UILabel、UITextView、UITextField的attributedText的设置。
* 包含的属性设置：
    * 段落样式
    * 阴影
    * 文本字体、颜色
    * 文本所在区域对应的背景颜色
    * 连体字
    * 字间距
    * 删除线、下划线，及其线条颜色
    * 描边，及其颜色
    * 斜体字
    * 上标 下标
    * 拉伸
    * 链接
    * 通过html源码加载富文本
    * 通过url添加图片到富文本
    * 添加自定义view，可用于显示gif、自定义标签等等
    * 添加backgroundView，在文本背后的位置显示view
    * 文本、图片、自定义view的点击事件
    * 等等
## How to use

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
    
### 基本方法（UILabel和UITextView用法一样）
```swift
text.rz.colorfulConfer { (confer) in
    confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(15)

    confer.image(UIImage.init(named: "indexMore"))?.bounds(CGRect.init(x: 0, y: 0, width: 20, height: 20))
    confer.text("  姓名 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
    confer.text("rztime")?.font(UIFont.systemFont(ofSize: 15)).textColor(.black)
}
```

### 进阶用法（UILabel和UITextView用法一样）

* 点击、自定义view、backgroundView等等
```swift
label.rz.colorfulConfer { confer in
    // 给富文本添加点击事件tapAction或者clicked
    confer.text("<隐私政策>")?.font(.systemFont(ofSize: 17)).textColor(.red).tapAction("<隐私政策>")
    confer.text("<用户协议>")?.font(.systemFont(ofSize: 16)).textColor(.blue).clicked { sender, range in
        print("---用户协议")
    }
    // 添加自定义view，可以显示gif的UIImageView，view可以自行实现点击事件，也可以在后边添加tapAction或者clicked
    confer.view(gifView())?.size(.init(width: 200, height: 100), align: .center, font: .systemFont(ofSize: 16))
    // 给文本添加背景图，可以自行实现点击事件，也可以在后边添加tapAction或者clicked
    confer.text("hello")?.font(.systemFont(ofSize: 16)).textColor(.red).backgroundView { rects in
        return rects.compactMap { rect -> UIView in
            // 带圆角的view
            let view = UIView.init(frame: rect).qalpha(0.3).qbackgroundColor(.qhex("123456")).qcornerRadius(3, true)
            view.frame.size.height = 21
            view.qtap { view in
                print("--- 点击背景")
            }
            return view
        }
    }
}
label.rz.tapAction { label, tapActionId, range in
    print("\(tapActionId)") // <隐私政策>
}
如果不实现label.rz.tapAction()方法，则需要调用label.activeColorful(),否则clicked、backgroundView、自定义view将无法实现
```

* 自定义截断内容
```
// 系统默认超行时显示"..."，这可以使用自定义的内容去替换"..."
label.rz.set(attributedString: displayText, maxLine: 3, maxWidth: qscreenwidth - 40, lineBreakMode: .byTruncatingTail, placeHolder: customText)
```

* 超行时 折叠 展开
```
// UILabel UITextView 超行时显示 展开、折叠
// isFold: 默认当前是展开还是折叠状态，如果未超行，则完全显示，超行且折叠时就将showAllText追加在最后
// showAllText: 显示全文，需要实现tapAction，或者clicked
// foldtext: 收起，需要实现tapAction，或者clicked
$0.rz.tapAction { [weak self] label, tapActionId, range in
    if tapActionId == "...显示全文" {
        isFold = false
    } else if tapActionId == "收起" {
        isFold = true
    }
    // 刷新， 重新执行label.rz.set方法
}
label.rz.set(attributedString: displayText, maxLine: 3, maxWidth: qscreenwidth - 40, isFold: isFold, showAllText: showAllText, showFoldText: foldtext)
```

### NSAttributedString 转 HTML 行内样式的方法

可以参考[RZRichTextView](https://github.com/rztime/RZRichTextView)里[code2Html](https://github.com/rztime/RZRichTextView/blob/master/RZRichTextView/Classes/RZHtml.swift)方法

## 最后
* 在使用过程中，如果您发现有什么问题，欢迎向我反馈，谢谢
