function img_out = draw_superpixel_average(img, Label)
    % 获取图像尺寸
    [H, W, C] = size(img);
    
    % 初始化输出图像
    img_out = zeros(H, W, C, 'like', img);
    
    % 获取超像素的唯一标签
    unique_labels = unique(Label);
    
    % 遍历每个超像素
    for i = 1:length(unique_labels)
        % 获取当前超像素的掩码
        mask = (Label == unique_labels(i));
        
        % 计算该超像素区域的平均颜色
        for c = 1:C
            % 提取当前通道属于该超像素的所有像素
            pixel_values = img(:,:,c);
            mean_value = mean(pixel_values(mask)); % 计算均值
            
            % 赋值给输出图像
            img_out(:,:,c) = img_out(:,:,c) + uint8(mask) * mean_value;
        end
    end
end
