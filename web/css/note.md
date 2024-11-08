# CSS

css 层叠样式表

## css 选择器

可以将 CSS 选择器分为 5 类

### 简单选择器

简单选择器包括根据名称、id、类、通配符以及分组来选择元素

```css
/*根据标签名称选择*/
p {
  color: red;
}

/*根据id选择，#后跟元素的id。元素的 id 唯一，id 选择器适合选择一个唯一的元素。id 名称不能以数字开头*/
#para1 {
  color: red;
}

/*根据class选择，(.) 后跟元素的class*/
.center {
  color: red;
}

/* 通用选择器 * 选择页面的全部元素*/ 
* {
  color: blue;
}

/*分组选择，具有相同的样式，用逗号分割*/ 
h1, h2, p {
  color: blue;
}
```

### 组合器选择器

组合器是解释选择器之间关系的某种机制。CSS 中有 4 个不同的组合器。

- 后代选择器（空格）
- 子选择器（>）
- 相邻兄弟选择器(+)
- 通用兄弟选择器（～）

### 伪类选择器

伪类是用来定义元素的特殊状态的。

```css
/* 未访问的链接 */
a:link {
  color: #FF0000;
}

/* 已访问的链接 */
a:visited {
  color: #00FF00;
}

/* 鼠标悬停链接 */
a:hover {
  color: #FF00FF;
}

/* 已选择的链接 */
a:active {
  color: #0000FF;
}
```

> [!IMPORTANT]
> a:hover 必须在 CSS 定义中的 a:link 和 a:visited 之后，才能生效！a:active 必须在 CSS 定义中的 a:hover 之后才能生效！伪类名称对大小写不敏感。

### 伪元素选择器

CSS 的伪元素用于设置元素指定部分的样式，或在元素的内容之前或之后插入内容。

```css
selector::pseudo-element {
  property: value;
}

```

### 属性选择器

可以给带有特殊属性的 HTML 元素设置样式

```css
a[target="_blank"] { 
  background-color: yellow;
}
```

## 字体属性

### 字体系列

CSS 使用 `font-family` 来定义文本的字体系列。

```css
div {
  font-family: Arial, "Microsoft YaHei", "微软雅黑";
}
```

可以设置多个字体，多个字体之间使用，分割。由多个字符串组成的名称使用引号括起来。优先级从左到右递减，如果都找不到，则使用浏览器默认字体

### 字体大小

```css
p {
  font-size: 20px;
}
```

- px(像素)： ，绝对单位，代表屏幕中的每个点
- em：相对单位，元素【倍数】乘以父元素 px 值
- rem：相对单位，元素【倍数】乘以根元素的 px 值
- %：相对单位，元素通过百分比乘以父元素的 px 值
- medium：预设值，等于 16 px，是 h4 的预设值
- xx-small：medium 的 0.6 倍，是 h6 的预设值
- x-small：medium 的 0.75 倍
- small：medium 的 0.8 倍，是 h5 的预设值
- large：medium 的 1.1 倍，是 h3 的预设值
- x-large：medium 的 1.5 倍，是 h2 的预设值
- xx-large：medium 的 2 倍，是 h1 的预设值
- smaller：约为父层的 80%
- larger：约为父层的 120%

### 字体粗细

使用 `font-weight` 设置字体的粗细。

```css
p {
  font-weight: normal;
}
```

- normal：正常的字体，数值相当于 400
- bold：粗体，数值相当于 700
- bolder：特粗体
- lighter：细体

number 的范围 100~900

### 字体样式

CSS 使用 font-style 来设置文本的风格。

```css
p {
  font-style: italic;
}
```

- normal：正常的样式
- italic：斜体样式

### 混合写法

```css
p {
  font: font-style font-weight font-size font-family;
}
```

使用混合写法必须按照顺序书写，**不能颠倒顺序**，各个属性按空格隔开。至少需要设置 `font-size` 和 `font-family` 两个属性。

### 文本属性

CSS 文本属性可以定制文本外观，比如文本的颜色，对齐文本、装饰文本、文本缩进、行间距等。

#### 文本颜色

`color` 属性用来定义文本的颜色。

```css
div {
  color: red;
}
```

| 表示方式 | 属性值 |
| -------------- | --------------- |
| 预定义颜色值 | red, blud, green |
| 十六进制 | #ffffff, #000000, #29d794 |
| rgb | rgb(255,0,0) , rgb(100%, 0%, 0%)  |

#### 文本对齐

`text-align` 属性用来设置内容文本水平对齐方式。

```css
div {
  text-align: center;
}
```

| 属性值 | 解释 |
| -------------- | --------------- |
| left | 左对齐（默认） |
| center | 居中对齐 |
| right | 右对齐 |

#### 装饰文本

`text-decoration` 属性规定添加到文本的修饰。可以给文本添加下划线，删除线，上划线等。

```css
div {
  text-decoration: none;
}
```

| 属性值   | 描述    |
|--------------- | --------------- |
| none   | 默认，没有装饰线   |
| underline   | 下划线，a 标签自带下划线   |
| overline   | 上划线   |
| line-through   | 删除线   |

#### 文本缩进

`text-indent` 属性用来指定文本第一行的缩进，通常是将段落的首行缩进。

```css
div {
  text-indent: 2em;
}
```

#### 行间距

`line-height` 属性用来设置行间距（行高）。可以控制行与行之间的距离。

```css
div {
  line-height: 1.1
}
```

在设置行间距时，使用数字比使用带单位的距离更好，因为距离在空间不足的情况下字会被压缩到一起。

## css 引入方式

按照 CSS 的引入方式不同，CSS 分成 3 大类

1. 行内式
2. 内部嵌入式
3. 外部链接式

```html
<link rel="tylesheet" href="css 文件路径">
```

## 元素显示模式

- 块级元素：宽度默认为父级元素宽度的 100%， 但是文字的元素不能再放其他盒子了
- 行级元素：相邻元素在在一行，宽高设置无效，宽度就是里面内容的宽度，内部只能容纳文本和其他的行内元素
- 行内块元素：img、input、td 等同时具有块元素和行内元素的特点，成为行内块元素

### 模式转换

- 转为块级元素：display: block;
- 转为行内元素: display: inline;
- 转为行内块元素: display: inline-block;

## 文字垂直居中

设置行高等于盒子的高度

## 背景

### 背景颜色

```css
background-color: transparent | color;
/*使用rgba*/
background-color: rgba(0,0,0,0.5)
```

### 背景图片

```css
可以方便的控制位置
background-image: none|url;
```

### 背景平铺

```css
background-repeat: repeat | no-repeat | repeat-x | repeat-y
```

### 背景位置

```css
background-postion: x y;
```

### 背景图像固定

`background-attachment` 属性设置背景图像是否固定或随着页面其余部分滚动

```css
background-attachment : scroll | fixed;
```

### 背景复合写法

```css
background: 背景颜色 背景图片 背景平铺 背景附着 背景图像位置
```

## CSS 三大特性

CSS 有 3 个重要的特性：层叠性，继承性，优先级。

## 选择器权重

属性值后添加`!important` 的权重最大

```css
color: red
```

## 盒子模型

一个盒子从内到外：content -> padding -> border -> margin

### border

```css
border: border-width || border-style || border-color
```
