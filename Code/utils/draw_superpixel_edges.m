function outputImage = draw_superpixel_edges(image, SPLabel)
    % 在原图上绘制超像素边缘为红色
    
    % 检测超像素边界
    if size(image, 3) == 1
        image = repmat(image, [1, 1, 3]);
    end
    
    [rows, cols, ~] = size(image);
    edge_img = zeros(rows, cols);

    % 遍历每一个像素（忽略边界像素以避免越界）
    for i = 1:rows
        for j = 1:cols
            % 当前像素值
            current_pixel = SPLabel(i, j);

            % 检查上下左右像素值是否有不同
            if (SPLabel(max(1, i-1), j) ~= current_pixel) || ... % 上
               (SPLabel(min(rows, i+1), j) ~= current_pixel) || ... % 下
               (SPLabel(i, max(1, j-1)) ~= current_pixel) || ... % 左
               (SPLabel(i, min(cols, j+1)) ~= current_pixel)        % 右
                % 若邻居不同，则标记为边缘
                edge_img(i, j) = 1;
            end
        end
    end

    
    % 将原始图像转换为 RGB（若非 RGB 图像）
    if size(image, 3) == 1
        image = repmat(image, [1, 1, 3]);
    end
    
    % 创建一个与图像大小相同的副本用于绘制
    outputImage = image;
    
    % 将边缘部分涂成红色
    outputImage(:,:,1) = outputImage(:,:,1) .* uint8(~edge_img) + uint8(edge_img) * 255;
    outputImage(:,:,2) = outputImage(:,:,2) .* uint8(~edge_img);
    outputImage(:,:,3) = outputImage(:,:,3) .* uint8(~edge_img);
end
