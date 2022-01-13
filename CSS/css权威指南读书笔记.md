## CSS权威指南(the definitive guide)第四版读书笔记

### Chapter 7. Basic Visual Formatting

##### Inline Elements


* 基本概念

    - em框

        也称字符框，font-size确定了各字符框的高度

    - 内容区`content area`

        对于非替换元素，内容区即为各`em框`,连在一起构成的框，高度即为font-size

    - 行高`line-height`, 字体大小`font-size`, 行间距`leading`

        `leading` = `line-height` - `font-size`

    - 元素行内框`inline-box`

        对于非替换元素，元素行内框`inline-box`的高度即为该元素的`line-height`(实际上是内容区`font-size`加上行间距)
        对于替换元素(如img)，`inline-box`的高度即为内容区，因为行间距只适用于非替换元素

    - 行框`line-box`

        改行中出现的行内框的最高点和最低点的最小框

   内容区类似于块级元素的内容框

   行内元素的背景应用于内容区，及内边距

   非替换元素的内边距，边框及外边距对行内元素或其生成的框没有垂直效果；也就是说他们不会影响行内框的高度（也不会影响包含该元素的行框的高度）

   替换元素的外边距，边框，内边距确实会影响该元素的行内框的高度，相应的也会影响所在行的行框的高度

   替换元素设置负的上外边距会把上面一行往下拉，即会减少行内框的大小

    替换元素有固有的高度和宽度，但这不会影响`line-height`的值。在定义`vertical-align`为百分比时，需要通过`line-height`计算垂直对齐位置


   `line-height`只影响行内元素，而不（直接）影响块级元素。可以为块级元素设置`line-height`,但是这个值只是应用到块级元素的内联元素才会有影响。

   `width`,`height`,`vertical-align`不能应用到行内非替换元素

* Change Breaking Behavior: `box-decoration-break`属性

    `box-decoration-break`属性可以指定元素片段在跨行、跨列或跨页（如打印）时候的样式渲染表现。

    ```css
    box-decoration-break: slice;  /* 默认值 表示各个盒子断开的部分如同切割开一般。*/
    box-decoration-break: clone; /*表示断开的各个盒子样式独自渲染。*/
    ```


### Chapter 8. Padding,Borders,Outlines, and Margins

##### Borders

`border-style`默认值为`none`,如何声明`h1{border-width: 10px;}`将不会显示任何边框

透明边框：`border-color: transparent`
利用`transparent`,使用边框就像增加了额外的内边距一样；此外，还有一个好处就是能在你需要的时候使其可见。这张透明的边框相当于内边距，因为元素的背景会延伸到边框区。

外边距，内边距的百分数值，会相对于父元素的宽度计算（包括上下边距），而不是相对于高度计算。