##### 2.0.0

此次进行了大更新，统一了UILabel和UITextView关于富文本的用法，不需要区分了（跳过1.0，是为了和OC版本同步）

```
1.以前的 url(), link(), tapAction(), tapActionByLable(), 
删减统一后仅保留link(), tapAction(), 这两者的区别是link添加的url，会使文本为蓝色+下划线
原key：rztapLabel删除，替换改为key：rztapAction
```

```
2.UITextView的rz.didTapTextView()方法删掉，替换为与UILabel一样的.rz.tapAction()
```

```
3.新增confer.view()方法，可以添加自定义的view，本质是添加的NSAttachment,最终将自定义view显示在UILabel或者UITextView对应的位置上，实现了gif、自定义标签等功能
confer.view(gifView())?.size(.init(width: 200, height: 100), align: .center, font: .systemFont(ofSize: 16))                
```

```
4.新增backgroundView(), 可以用于对文本添加背景视图，设置圆角，背景图等等
confer.text("hello")?.backgroundView { rects in
    return rects.compactMap { rect -> UIView in
        let view = UIView.init(frame: rect).qalpha(0.3).qbackgroundColor(.qhex("123456")).qcornerRadius(3, true)
        view.frame.size.height = 21 // frame等可以按需调整
        view.qtap { view in
            print("--- 点击背景")
        }
        return view
    }
}
```

```
5.新增clicked()方法，可直接用block来处理文本、图片、backgroundView的点击事件
confer.text("hello").clicked({ sender, range in
    
})
```

```
新增TextLayoutRZ，用于计算富文本的相关信息
```

本次更新后，解决了UILabel在加载了大量可点击文本时，导致的hitTest方法耗时卡顿的问题

##### 0.7.0

新增了markdown文档转换为html的方法
```
// 1.初始化(可以提前初始化，用于下载最新的js解析方法)  
MarkDownRZ.asyncInit()
// 2.解析 解析md后的html，没有任何的样式，需要自行组装head里style：颜色、字号、列表、代码等等）
let html = MarkDownRZ.parse(md)
```

##### 0.6.0

完善了iOS 14-18 支持的富文本属性
优化了富文本截断的内部的实现

##### 0.5.0 

未做修改，只是将最低版本设置为iOS11


##### 0.4.1

修复了html转换成富文本时，html转换后内容为空导致的崩溃


##### 0.4.0

新增对富文本进行截断
```
let attr = NSAttributedString.init(string: "")
let newattr = attr.rz.attributedStringBy(maxline: 3, maxWidth: 300, lineBreakMode: .byTruncatingTail, placeHolder: NSAttributedString.init(string: "..."))
```

新增给paragraphStyle里添加行数限制 如：
```
/// 只对2中的文本进行行数计算，如果前后有1、3，将不适用
confer.text("1").
confer.text("2")?.paragraphStyle?.numberOfLines(3, maxWidth: width).lineBreakMode(.byTruncatingMiddle)
confer.text("3").
```

新增NSAttributedString里关键字标记

##### 0.3.0

新增confer.text().custom(key, value) 可以添加自定义的属性
新增iOS15相关的属性方法（这里边的属性有什么效果，还没用过，我也不知道）
给Label添加tapAction, 只要添加了confer.text(“文本”).tapActionByLable("xxx") （即.rztapLabel属性），那么点击“文本”, label.rz.tapAciton()方法将被回调
给Label添加超过行数后，末尾添加"折叠" “收起”的文本以及点击事件回调

##### 0.2.2

修改使用方法 test.rz_xxxxxx为 test.rz.xxxx 

