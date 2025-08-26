
function ASA = CalASA2(Label, GT)

    % 获取图像的大小
    [rows, cols] = size(Label);

    % 获取唯一的超像素标签数目
    uniqueSuperpixels = unique(Label);
    numSuperpixels = length(uniqueSuperpixels);

    % 初始化正确像素计数
    correctPixels = 0;

    % 遍历每个超像素
    for i = 1:numSuperpixels
        % 找到每个超像素的像素索引
        superpixelMask = (Label == uniqueSuperpixels(i));

        % 获取当前超像素区域中真实分割的标签
        gtLabels = GT(superpixelMask);

        % 找到该超像素区域中像素最多的真实标签（即该区域的主要类别）
        majorityLabel = mode(gtLabels);

        % 计算该超像素区域中与真实标签匹配的像素数
        correctPixels = correctPixels + sum(gtLabels == majorityLabel);
    end

    % 计算总像素数
    totalPixels = rows * cols;

    % 计算 ASA
    ASA = correctPixels / totalPixels;

    fprintf('Average Segmentation Accuracy (ASA): %.4f\n', ASA);
end