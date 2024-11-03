# HTML

## 基本结构和标签

```html
<html>
    <head>
        <title>标题</title>
    </head>
    <body>
        this is my first html.
    </body>
</html>
```

### 基本的默认结构

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
</body>
</html>
```

- `<!DOCTYPE html>` 是 HTML 文档类型声明，它告诉浏览器使用 HTML5 规范来解析文档。
- `<html>` 标签是 HTML 文档的根元素，包含所有其他元素。
  - lang 属性设置了 HTML 文档的语言，用于为搜索引擎提供信息。
- `<meta charset="UTF-8">` 规定字符编码，用于支持不同的语言和字符。
- `<meta name="viewport" content="width=device-width, initial-scale=1.0">` 设置视口，以适应不同大小的屏幕。

### 常用标签

#### 标题标签

```html
<h1>标题1</h1>
...
<h6>标题6</h6>
 ```

#### 段落标签

段落标签 `<p>段落</p>` 可以将 HTML 文档中的文本分成多个段落。

文本在一个段落中会根据浏览器窗口的宽度自动换行。

#### 换行标签

`<br>` 标签用于插入一个换行符，它不会创建新的段落。

#### 文本格式化标签

- `<b>` 和 `<strong>`：用于将文本标记为粗体。
- `<i>` 和 `<em>`：用于将文本标记为斜体。
- `<u>`：用于将文本标记为下划线。
- `<s>`：用于将文本标记为删除线。
- `<sub>`：用于将文本标记为下标。
- `<sup>`：用于将文本标记为上标。

#### div 和 span 标签

`div` 和 `span` 没有语义义，它们只是为了在 HTML 中创建块级元素和行内元素。

#### 图像标签

`<img>` 标签用于在 HTML 文档中插入图像。
`src` 属性用于指定图像的路径。
`alt` 属性用于在图像无法显示时显示替代文本。
`title` 属性用于为图像添加鼠标悬停时的提示文本。

```html
<img src="image.jpg" alt="图像无法显示时的替代文本" title="图像的提示文本">
```

#### 链接标签

`<a>` 标签用于创建超链接，它允许用户通过点击链接导航到其他页面。
`href` 属性用于指定链接的目标地址。
`target` 属性用于指定链接打开的方式，如 `_self` 是默认值，在当前窗口打开，`_blank` 在新窗口中打开。

```html
<a href="https://www.example.com">这是一个超链接</a>
```

1. 外部链接：`<a href="https://www.example.com">这是一个超链接</a>`
2. 内部链接：`<a href="internal.html">这是一个内部链接</a>`，内部链接不要加 `http://` 或 `https://` 前缀。
3. 空链接：`<a href="#">这是一个空链接</a>`
4. 锚点链接：`<a href="#section1">这是一个锚点链接</a>`，锚点链接需要在目标页面中使用 `id` 属性来定义锚点。

### 其他标签

#### 表格标签

```html
<table>
  <tr>
    <th>表头文字</th>
  </tr>
  <tr>
    <td>单元格内的文字</td>
    ...
  </tr>
  ...
</table>
```

##### 表格结构标签

在表格标签中，可以使用 `<thead>`  标签表示表格的头部区域，`<tbody>` 标签表示表格的主体区域。

```html
<table>
  <thead>
    <tr>
      <th>表头文字</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>单元格内的文字</td>
      ...
    </tr>
    ...
  </tbody>
</table>
```

##### 合并单元格

合并单元格的方式有两种：

- 跨行合并：`rowspan="合并单元格的个数"`
- 跨列合并：`colspan="合并单元格的个数"`

#### 列表标签

列表最大的特点就是整齐有序，很适合用来布局。
根据使用的情景不同，可以分为三大类：无序列表、有序列表和自定义列表。

##### 无序列表

`<ul>` 标签表示 HTML 中的无序列表，一般会以项目符号呈现列表项，而列表项使用 `<li>` 标签定义，`<ul>` 标签中只能放 `<li>`。

```html
<ul>
  <li>列表项</li>
  <li>列表项</li>
  <li>列表项</li>
</ul>
```

##### 有序列表

`<ol>` 标签用于定义有序列表，列表排序以数字来展示，使用 `<li>` 来表示列表项。

```html
<ol>
  <li>列表项</li>
  <li>列表项</li>
  <li>列表项</li>
</ol>
```

##### 自定义列表

自定义列表通常用于对术语或名词进行解释和描述，自定义列表的列表项没有任何的符号。

`<dl>` 标签用于定义描述列表，该标签会与 `<dt>`（定义项目名称）和 `<dd>`（列表项）一起食用

```html
<dl>
  <dt>项目名称</dt>
  <dd>描述1</dd>
  <dd>描述2</dd>
  <dd>描述3</dd>
</dl>
```
