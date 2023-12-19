## 代码构成
### ① rnn.py 
- `def weights_init(m)`

  目的：用于对线性层进行权重初始化，采用均匀分布 $U(-w_{\text{bound}}, w_{\text{bound}})$ 的方式对权重进行初始化，偏置初始化为0。
  在模型初始化时调用这个函数。
- ```class word_embedding(nn.Module)```
