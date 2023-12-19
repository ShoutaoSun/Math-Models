## 代码构成
### ① rnn.py 
- `def weights_init(m)`

  目的：用于对线性层进行权重初始化，采用均匀分布$\`U(-w_bound, w_bound)`$的方式
- ```class word_embedding(nn.Module)```
