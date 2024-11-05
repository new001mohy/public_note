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
