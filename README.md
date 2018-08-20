# RZColorfulSwift
NSAttributedString 富文本方法 (图文混排、多样式文本)

### [Objc版本看这里](https://github.com/rztime/RZColorful)

* NSAttributedString 的多样化设置(文字字体、颜色、阴影、段落样式、url、下划线，以及图文混排等等)
* 添加UITextField、UITextView、UILabel的attributedText的富文本设置。
* 富文本方法内容可单独抽出来,在下边这个文件中
```
RZColorful
```

## 关于RZColorfulSwift
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
        * RZColorfulConferrer.swift                         富文本中对文字、图片、段落、阴影、网页源码等归纳集合
        * RZTextAttribute.swift                                对文字的属性方法设置集合
        * RZImageAttribute.swift                            对图片的 属性方法集合
        * RZImageUrlAttribute.swift                       对通过url加载的图片的属性方法集合
        * RZHtmlAttribute.swift                              对加载网页源码的富文本的属性的集合
        * RZParagraphStyle.swift                           对段落样式的一个属性方法集合
        * RZShadowStyle.swift                               对阴影样式的一个属性方法集合
    * Core 对UILabel、UITextView、UITextField添加的富文本快捷写入提供入口
        * NSAttributedString       富文本的方法
        * UILabel                       
        * UITextView
        * UITextField
可以覆盖原文本、追加、以及指定位置插入等功能
    
### 基本的简单使用方法与OC版本差不多 [查看详细用法](https://github.com/rztime/RZColorful)
```swift
text.rz_colorfulConfer { (confer) in
    confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(15)

    confer.image(UIImage.init(named: "indexMore"))?.bounds(CGRect.init(x: 0, y: 0, width: 20, height: 20))
    confer.text("  姓名 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
    confer.text("rztime")?.font(UIFont.systemFont(ofSize: 15)).textColor(.black)
}

```

## 注意

* 尽管我已经在代码中已经处理过（弱）引用问题，但是在实际运用写入text时，还是请尽量检查避免循环引用


## 最后
* 在使用过程中，如果您发现有什么问题，欢迎向我反馈，谢谢
