% 假设有一个能量函数 E(x) = c' * x + x' * Q * x，其中 c 是线性系数，Q 是二次项系数矩阵
% 定义变量数目
N = 10;

% 随机初始化线性项 c 和二次项系数矩阵 Q
c = rand(N, 1);
Q = rand(N, N);

% 构造图的边权重矩阵
% 线性项转化为源和汇的连接权重
source_weights = max(0, c); % 将 c 转化为连接到源的权重
sink_weights = max(0, -c);  % 将 -c 转化为连接到汇的权重

% 二次项转换为图中的边权重
edge_weights = abs(Q);

% 使用 QPBO 工具箱计算二次伪布尔优化解
labels = QPBO(source_weights, sink_weights, edge_weights);

% 输出解
disp('QPBO结果标签：');
disp(labels);
