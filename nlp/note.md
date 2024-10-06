# NLP

## 基础介绍

### 监督学习范式（The Supervised Learning Paradigm）

可将监督学习的范式分解为6个主要的概念：

- Observations：观测值，使用 x 表示观测值
- Targets：真实值，使用 y 表示
- Model：模型是一个数学表达式或函数
- Predictions：预测值，用一个 “hat” 表示
- Parameters：有时也称为权重，使用符号 w 表示
- Loss function: 损失函数，比较 y he hat 之间距离的函数，使用 L 表示

$$
  hat = Model_w(x)
$$

$$
  lossValue = L(y,hat)
$$

$$
  Min(\sum_{i=1}^n lossValue_i)
$$
