function BR = CalBR2(L, GT)
    % 假设 L 是超像素标签图，GT 是真实的分割图
    % L 和 GT 的大小应相同

    % 计算超像素的边界掩码
    boundaryL = boundarymask(L);

    % 计算真实分割的边界掩码
    boundaryGT = boundarymask(GT);

    % 设置距离阈值
    maxDistance = 2; % 可以根据需要调整

    % 使用 bwdist 计算每个边界像素到其他边界的最小距离
    distancesToGT = bwdist(boundaryL);

    % 计算预测边界的有效匹配
    matchedBoundaries = distancesToGT <= maxDistance & boundaryGT;

    % 计算真实边界的数量
    numGTBoundaries = sum(boundaryGT(:));

    % 计算匹配的边界数
    numMatchedBoundaries = sum(matchedBoundaries(:));

    % 计算 Boundary Recall (BR)
    BR = numMatchedBoundaries / numGTBoundaries;

    fprintf('Boundary Recall (BR): %.4f\n', BR);

end