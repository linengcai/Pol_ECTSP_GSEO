function [Kmat] = adaptiveKmat(X,kmax,kmin)
X = X';
kmax = kmax+1;
% [idx, distX] = knnsearch(X,X,'k',kmax);
% 李能才修改
[idx, distX] = customKNN(X,X,kmax);

[N,Dx] = size(X);
% 使用 tabulate 统计 idx 中每个样本在其他样本的邻居列表中出现的次数，即记录该样本被其他样本视为邻居的频率
% 第一列：每个样本的索引。
% 第二列：对应索引在其他样本邻居列表中出现的次数。
% 第三列：出现频率的百分比（这里暂不使用）。
degree_x = tabulate(idx(:));
Kmat = degree_x(:,2);
Kmat(Kmat >= kmax)=kmax;
Kmat(Kmat <= kmin)=kmin;
if length(Kmat) < N
    Kmat(length(Kmat)+1:N) = kmin;
end
