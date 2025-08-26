function Label = DualTimeSPFunction(image_t1, image_t2, edge, s, rs_scale)

% 归一化Span
span1 = image_t1(:,:,1) + image_t1(:,:,2) + image_t1(:,:,3);
span2 = image_t2(:,:,1) + image_t2(:,:,2) + image_t2(:,:,3);
spanmax = min(max([span1(:);span2(:)]), mean([span1(:);span2(:)]) * 2) ;
span1 = min(1, span1 ./ spanmax);
span2 = min(1, span2 ./ spanmax);


%% 计算初始超像素中心
m = size(image_t1, 1); % 行 
n = size(image_t1, 2); % 列

% 得到方形分布
[rowC_init, colC_init] = InitSPCenterGrid(m, n, s);

[h, w] = size(rowC_init);

rowC = reshape(rowC_init, h*w, 1);
colC = reshape(colC_init, h*w, 1);
regionSizeC = ones(size(rowC)) * s;


lenSP = length(rowC);

% 保存一个初始的超像素中心，用于确定搜索范围
rowC_init = rowC;
colC_init = colC;

% 初始超像素中心放置于边缘强度的
for i = 1 : lenSP
    % 3*3的block
    block = edge(rowC(i) - 1 : rowC(i) + 1, colC(i) - 1 : colC(i) + 1);
    [minVal, idxArr] = min(block(:));
    % 求最小的edge的坐标
    jOffset = floor((idxArr(1) + 2) / 3);
    iOffset = idxArr(1) - 3 * (jOffset - 1);
    rowC(i) = rowC(i) + iOffset - 2;
    colC(i) = colC(i) + jOffset - 2;
end

%%  kmeans超像素分割
M1 = reshape(image_t1, m * n, size(image_t1, 3));  % 像素值重排 matlab对三维数据处理很弱
M2 = reshape(image_t2, m * n, size(image_t2, 3));
Label = zeros(m, n) - 1; % 标签
dist = Inf * ones(m, n); % 每个像素的最小距离

% 计算初始中心
colorCenter = zeros(lenSP, size(image_t1, 3) * 2);
SpanCenter = zeros(lenSP, 2);
for i = 1 : lenSP
    colorCenter(i, 1:9) = image_t1(rowC(i), colC(i), :);
    colorCenter(i, 10:18) = image_t2(rowC(i), colC(i), :);
    SpanCenter(i, 1) = span1(rowC(i), colC(i), :);
    SpanCenter(i, 2) = span2(rowC(i), colC(i), :);
end
Centers = cat(2, colorCenter, SpanCenter, rowC, colC); % 在第2维 拼接到一起

% 开始循环
iter = 0;
maxIter = 50;
while(1)
    iter = iter + 1;
    
    if iter == 2
        tic
    end
    
    if iter == 6
        toc
%         break
    end
    
    dis = Inf * ones(m, n);
    if mod(iter, 5) == 0
        disp(iter);
    end
    if iter > maxIter
        break
    end
    
    Centers_last = Centers;
    % 按照超像素个数进行循环
    for k = 1 : lenSP
        rowCidx = Centers(k, 21);
        colCidx = Centers(k, 22); %聚类中心坐标
        rs = round(regionSizeC(k) * rs_scale);
        rowStart = max(1, rowC_init(k) - rs);
        rowEnd = min(m, rowC_init(k) + rs);
        colStart = max(1, colC_init(k) - rs);
        colEnd = min(n, colC_init(k) + rs);
        
        colorC1 = Centers(k, 1:9);
        colorC2 = Centers(k, 10:18);
        
        spanC1 = Centers(k, 19);
        spanC2 = Centers(k, 20);
        
        % 循环处理block
        for i = rowStart : rowEnd
            for j = colStart : colEnd
                
                colorCur1 = M1((j - 1) * m + i, :);
                colorCur2 = M2((j - 1) * m + i, :);
                
                dW1 = Cal_JBLD2(colorCur1, colorC1); % 实验所采用方法
                dW2 = Cal_JBLD2(colorCur2, colorC2);
                
                
                dW = 1 * max(dW1, dW2);
                if dW > 2.5
                    dW = 2.5;
                end
                
                dS = 1 * sqrt((i - rowCidx)^2 + (j - colCidx)^2) / rs * rs_scale; % 让超像素仍然保持原来s的紧致度
                
                dT1 = abs(spanC1 - span1(i, j)) ./ max(spanC1, span1(i, j));
                dT2 = abs(spanC2 - span2(i, j)) ./ max(spanC2, span2(i, j)); % 百分比误差
                dT = 1 * max(dT1, dT2);
                
                dE = 1.5 * FindEdgeLineMax(edge, [i, j], [rowCidx, colCidx]);
%                 dE = 0;
                
                d = dW * (1 + dT) + dS + dE;
                
                if d < dis(i, j)
                    dis(i, j) = d;
                    Label(i, j) = k;
                end
                
            end
        end
    end
    
    if iter > 5 % 5
        % 后处理
        Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label);
    end
    
    % 更新中心
    Centers = UpdateCenter(Label, rowC_init, colC_init, regionSizeC, rs_scale, M1, M2, span1, span2);
    
    % early stop
    diff = Centers(:,21:22) - Centers_last(:,21:22);
%     disp(sum(abs(diff(:))))
    if sum(abs(diff(:))) < lenSP / 9 %残差低于阈值，结束迭代
        disp(sum(abs(diff(:))));
        break;
    end
    
    if 0
        % 创建边界掩码
        Boundary = boundarymask(Label);
        % 显示原图像和带标签的图像
        figure;
        subplot(1,2,1);
        imshow(imoverlay(img_pauli1, Boundary, 'red')); % 原图上叠加边界
        subplot(1,2,2);
        imshow(imoverlay(img_pauli2, Boundary, 'red')); % 原图上叠加边界
        title('原图与超像素边界叠加');
    end
end

% 后处理
Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label);











