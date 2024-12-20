# 机器学习

## 线性回归

举例，有一张工资、年龄和银行给的贷款额度的一张表:

| 工资 | 年龄 | 额度 |
| --------------- | --------------- | --------------- |
| 4000 | 25 | 20000 |
| 8000 | 30 | 70000 |
| 5000 | 28 | 35000 |
| 7500 | 33 | 50000 |
| 12000 | 40 | 85000 |

- 数据：工资和年龄（2 个特征）
- 目标：预测银行会贷款多少钱（标签）
- 考虑：工资和年龄都会影响贷款额度，那它们各自有多大的影响呢？（参数）

这个问题可以使用一个方程来表示它们之间的关系。

$y = \theta_1x_1 + \theta_2x_2$

但是真实的数据可能并不严格遵循这个线性关系，我们只能寻找一个平面去尽可能地去拟合真实的数据。

假设 θ1 是年龄的参数， θ2 是工资的参数。
那拟合的平面为：

$ h_\theta(x) = \theta_0 + \theta_1x_1 + \theta_2x_2 $

θ1 和 θ2 是权重项，θ0是偏置项，调整偏置项可以对拟合的结果进行微调。

想要能够使用矩阵进行计算，上面的 θ0 并不符合，我们可以添加一个虚拟的数据项：

$ h_\theta(x) = \theta_0x_0 + \theta_1x_1 + \theta_2x_2 $

整合之后为：

$$ h_\theta(x) = \sum_{i=0}^k \theta_ix_i=\theta^Tx$$

真实值和预测值之间的差异，使用 $\varepsilon$ 来表示该误差。**误差项应该服从高斯(正向)分布**

对于每个样本：$y^{(i)} = \theta^Tx^{(i)} + \varepsilon^{(i)}$

目标函数（损失函数）
$$
    J(\theta) = \frac{1}{2}\sum_{i=1}^m(y^{(y)}-\theta^Tx^{(i)})^2
$$

求解 θ 使得 J(θ) 越小越好

$$
    \theta = (X^TX)^{-1}X^Ty
$$

## 梯度下降

梯度是一个向量，函数沿着该向量的变化最快，梯度下降即是函数下降的最快。
当我们得到一个目标函数后需要对齐进行求解，这个过程的目标是 loss 函数尽可能快地降低。那沿着该 loss 函数该点的切线方向下降最快，即为梯度下降。

在下降时，步长应尽可能地小，才能下降地更快。

- 批量梯度下降：容易得到最优解，但是每次都需要考虑所有的样本，速度很慢
- 随机梯度下降：每次找一个样本，迭代速度快，但不一定每次都沿着收敛的方向
- 小批量梯度下降：每次更新选择一小部分的数据进行计算

so 想要结果尽可能地好，一批的数据量就应该尽可能地大（通常大于等于 2<<6）， 学习率（learning rate）或者步长尽可能地小
