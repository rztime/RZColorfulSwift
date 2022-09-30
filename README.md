# RZColorfulSwift
NSAttributedString 富文本方法 (图文混排、多样式文本)

## Author

rztime, rztime@vip.qq.com  QQ群：580839749

### [Objc版本看这里](https://github.com/rztime/RZColorful)
### 更新日志
[更新日志](https://github.com/rztime/RZColorfulSwift/blob/master/UpdateLog.md)

* NSAttributedString 的多样化设置(文字字体、颜色、阴影、段落样式、url、下划线，以及图文混排等等)
* 添加UITextField、UITextView、UILabel的attributedText的富文本设置。


## 关于RZColorfulSwift
* 对NSAttributeString的初始化做支持
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
        * ColorfulConferrerRZ.swift                         富文本中对文字、图片、段落、阴影、网页源码等归纳集合
        * TextAttributeRZ.swift                                对文字的属性方法设置集合
        * ImageAttributeRZ.swift                            对图片的 属性方法集合
        * ParagraphStyleRZ.swift                           对段落样式的一个属性方法集合
        * ShadowStyleRZ.swift                               对阴影样式的一个属性方法集合
    * Core 对UILabel、UITextView、UITextField添加的富文本快捷写入提供入口
        * NSAttributedString       富文本的方法
        * UILabel                       
        * UITextView
        * UITextField
可以覆盖原文本、追加、以及指定位置插入等功能
    
### 基本的简单使用方法与OC版本差不多 [查看详细用法](https://github.com/rztime/RZColorful)
```swift
text.rz.colorfulConfer { (confer) in
    confer.paragraphStyle?.lineSpacing(10).paragraphSpacingBefore(15)

    confer.image(UIImage.init(named: "indexMore"))?.bounds(CGRect.init(x: 0, y: 0, width: 20, height: 20))
    confer.text("  姓名 : ")?.font(UIFont.systemFont(ofSize: 15)).textColor(.gray)
    confer.text("rztime")?.font(UIFont.systemFont(ofSize: 15)).textColor(.black)
}

```

### 给UITextView添加文本点击事件
```swift
text.rz.colorfulConfer { confer in
    confer.text("哈哈哈哈")?.font(.systemFont(ofSize: 17)).textColor(.black)
    confer.text("可点击字符串")?.font(.systemFont(ofSize: 17)).textColor(.red).tapAction("111111")
} 
text.rz.didTapTextView { (tabObj, textview) -> Bool in
    print("text:\(tabObj)")  /// text:111111
    return false
}

```


### 给UILabel添加文本点击事件

只需要给富文本添加tapActionByLable(即.rztapLabel)属性。
注意，不要设置label.textAlignment，否则可能会导致出错。因为内部用的UITextView计算的点击位置的文本，label设置对齐方式之后，只要某一段富文本未设置段落属性，则这一段富文本对齐方式将被替换，而富文本在UITextView并不会被替换。
所以如果要设置对齐方式，直接设置在confer.text().paragraphStyle?.alignment(.left)
```swift
label.rz.colorfulConfer { confer in
    confer.text("哈哈哈哈\n")?.font(.systemFont(ofSize: 18)).textColor(.black)
    confer.text("可点击文本1")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("1111").paragraphStyle?.alignment(.left)
    confer.text("\n")
    confer.text("可点击文本2")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("22222").paragraphStyle?.alignment(.center)
    confer.text("\n")
}
label.rz.tapAction { label, tapActionId in
    print("tapActionId:\(tapActionId)")
}

```

### UILabel支持超过行数后，显示 "折叠"  "展开", 实现tapAction点击事件，并刷新，可以实现展开收起

```swift
class LabelFoldModel {
    var isFold = true
    let attributedString = NSAttributedString.rz.colorfulConfer { confer in
        let text =
        """
        “中国人的饭碗任何时候都要牢牢端在自己手中，饭碗主要装中国粮”“保证粮食安全，大家都有责任，党政同责要真正见效”，习近平总书记强调指出。
        民为国基，谷为民命。粮食问题不仅要算“经济账”，更要算“政治账”；不仅要顾当前，还要看长远。
        \n今年，我国粮食生产喜获丰收，产量保持在1.3万亿斤以上，为开新局、应变局、稳大局发挥重要作用。但也要看到，当前我国粮食需求刚性增长，资源环境约束日益趋紧
        \n粮食增面积、提产量的难度越来越大。全球新冠肺炎疫情持续蔓延，气候变化影响日益加剧，保障粮食供应链稳定难度加大。
        """
        confer.text(text)?.textColor(.black).font(.systemFont(ofSize: 16))
    }
    let showAll = NSAttributedString.rz.colorfulConfer { confer in
        confer.text("...全部")?.textColor(.red).font(.systemFont(ofSize: 16)).tapActionByLable("all")
    }
    let showFold = NSAttributedString.rz.colorfulConfer { confer in
        confer.text("...折叠")?.textColor(.red).font(.systemFont(ofSize: 16)).tapActionByLable("fold")
    }
}

/// 设置文本超过4行，则追加“...全部”  全部显示时追加“...折叠”  
let label = UILabel()
label.frame = .init(x: 10, y: 100, width: 400, height: 500)
cell.label.rz.tapAction { [weak self] (label, tapActionId) in
    let item = self?.items[label.tag]
    if tapActionId == "all" {
        item?.isFold = false
    } else if tapActionId == "fold" {
        item?.isFold = true
    }
    reload()
}

func reload() {
    let item = LabelFoldModel()
    label.rz.set(attributedString: item.attributedString, maxLine: 4, maxWidth: 400, isFold: item.isFold, showAllText: item.showAll, showFoldText: item.showFold)
}

```


## 注意

* 尽管我已经在代码中已经处理过（弱）引用问题，但是在实际运用写入text时，还是请尽量检查避免循环引用


# 关于 NSAttributedString 转 HTML

### 系统提供的方法
```swift
    /// 将富文本编码成html标签
    func codingToCompleteHtml() -> String? {
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
```
其css样式，主要在doc文档的style中，以下部分属性不支持
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
NSAttributedString.rz.codingToCompleteHtmlByWeb()
```

这里将我自己已知的不支持的css加了进去
看'HtmlTransformRZ.share.webLabels'

也可以通过HtmlTransformRZ.share.webLabels插入自定义的需要写入到style的标签
可以参考webLabels的初始化来完成自定义

另外，按照数组顺序，优先级高的在前

## 最后
* 在使用过程中，如果您发现有什么问题，欢迎向我反馈，谢谢
