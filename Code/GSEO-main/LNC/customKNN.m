function [indices, distances] = customKNN(X, Y, k)
    % X: 训练数据集，每行是一个样本
    % Y: 测试数据集，每行是一个样本
    % k: KNN 中的 k 值
    % distanceFunc: 自定义距离函数句柄 (如 @euclideanDistance 或 @manhattanDistance)
    % indices: 每个测试样本最近的 k 个邻居在训练集中的索引
    % distances: 每个测试样本最近的 k 个邻居的距离
    
    numTest = size(Y, 1);     % 测试集样本数量
    numTrain = size(X, 1);    % 训练集样本数量
    indices = zeros(numTest, k);    % 初始化输出索引矩阵
    distances = zeros(numTest, k);  % 初始化输出距离矩阵
    
    % 遍历每个测试样本
    for i = 1:numTest
        currentDistances = zeros(numTrain, 1); % 当前测试样本到每个训练样本的距离
        
        % 计算当前测试样本到所有训练样本的距离
        for j = 1:numTrain
%             currentDistances(j) = featureDist(Y(i, :), X(j, :));
            currentDistances(j) = featureDistPTD(Y(i, :), X(j, :));
        end
        
        % 找到距离最近的 k 个邻居
        [sortedDistances, sortedIndices] = sort(currentDistances);
        indices(i, :) = sortedIndices(1:k);      % 最近的 k 个邻居的索引
        distances(i, :) = sortedDistances(1:k);  % 最近的 k 个邻居的距离
    end
end

% 示例距离函数：欧几里得距离
function d = euclideanDistance(x1, x2)
    d = sqrt(sum((x1 - x2).^2));
end

% 示例距离函数：曼哈顿距离
function d = manhattanDistance(x1, x2)
    d = sum(abs(x1 - x2));
end
