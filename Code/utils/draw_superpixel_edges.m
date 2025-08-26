function outputImage = draw_superpixel_edges(image, SPLabel)
    % ��ԭͼ�ϻ��Ƴ����ر�ԵΪ��ɫ
    
    % ��ⳬ���ر߽�
    if size(image, 3) == 1
        image = repmat(image, [1, 1, 3]);
    end
    
    [rows, cols, ~] = size(image);
    edge_img = zeros(rows, cols);

    % ����ÿһ�����أ����Ա߽������Ա���Խ�磩
    for i = 1:rows
        for j = 1:cols
            % ��ǰ����ֵ
            current_pixel = SPLabel(i, j);

            % ���������������ֵ�Ƿ��в�ͬ
            if (SPLabel(max(1, i-1), j) ~= current_pixel) || ... % ��
               (SPLabel(min(rows, i+1), j) ~= current_pixel) || ... % ��
               (SPLabel(i, max(1, j-1)) ~= current_pixel) || ... % ��
               (SPLabel(i, min(cols, j+1)) ~= current_pixel)        % ��
                % ���ھӲ�ͬ������Ϊ��Ե
                edge_img(i, j) = 1;
            end
        end
    end

    
    % ��ԭʼͼ��ת��Ϊ RGB������ RGB ͼ��
    if size(image, 3) == 1
        image = repmat(image, [1, 1, 3]);
    end
    
    % ����һ����ͼ���С��ͬ�ĸ������ڻ���
    outputImage = image;
    
    % ����Ե����Ϳ�ɺ�ɫ
    outputImage(:,:,1) = outputImage(:,:,1) .* uint8(~edge_img) + uint8(edge_img) * 255;
    outputImage(:,:,2) = outputImage(:,:,2) .* uint8(~edge_img);
    outputImage(:,:,3) = outputImage(:,:,3) .* uint8(~edge_img);
end
