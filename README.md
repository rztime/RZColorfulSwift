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


# 关于 NSAttributedString 转 HTML

### 系统提供的方法
```swift
public extension NSAttributedString {
    /// 将富文本编码成html标签
    func rz_codingToCompleteHtml() -> String? {
        do {
            let exportParams = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes: exportParams)
            var string = String.init(data: htmlData, encoding: String.Encoding.utf8)
            string = string?.replacingOccurrences(of: "pt;", with: "px;")
            string = string?.replacingOccurrences(of: "pt}", with: "px}")
            return string
        } catch {
            return nil
        }
    }
}
```
其css样式，主要在doc文档的style中，所以部分属性不支持
* 删除线、下划线、斜体、扩展、描边、书写方向等

为了支持这些属性，所以必须将其css写入到对应的文本style中，而NSAttributedString转换为html之后，文档比较多，如果通过其他方式去找这些样式，比较麻烦，所以最好是直接将style带入到对应的文本中去，这样就比较好解决
* 1.对富文本设置NSAttributedString.Key.link，我们可以知道，\<\a href="link" 这个link就是我们设置的内容，也只有这个，是除了文本之外，可以带入到html的东西，所以基于此，有一个取巧方法
* 2.对'删除线、下划线、斜体、扩展、描边、书写方向等'这些系统不支持的css样式，选择自己设置好css，然后将css设置到NSAttributedString.Key.link，最后通过将href改变，就完成了style的设置
        如：

            confer.text("删除线 下划线")?.strikethroughStyle(.single).strikethroughColor(.black).textColor(.red).font(.systemFont(ofSize: 17)).underlineStyle(.single).underlineColor(.red)
        

            正常转换之后为 <p class='p1'><span class="s1"> 删除线 下划线</span></p>

            通过写入NSAttributedString.Key.link变成
            <p class="p1"><span class="s1"><a style="text-decoration: line-through underline; text-decoration-color: #000000FF;"> 删除线 ;<span class="s2"> </span>下划线</a></span></p>
            这样就取巧，将不支持的属性css样式添加进去了，虽然这里是<a>标签，因为没有href，所以和普通标签一样
        

### 参考代码
```swift 
NSAttributedString.rz_codingToCompleteHtmlByWeb()
```

这里将我自己已知的不支持的css加了进去
看'RZHtmlTransform.share.webLabels'

也可以通过RZHtmlTransform.share.webLabels插入自定义的需要写入到style的标签
可以参考webLabels的初始化来完成自定义

另外，按照数组顺序，优先级高的在前

## 最后
* 在使用过程中，如果您发现有什么问题，欢迎向我反馈，谢谢
