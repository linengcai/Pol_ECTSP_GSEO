function img_out = draw_superpixel_average(img, Label)
    % ��ȡͼ��ߴ�
    [H, W, C] = size(img);
    
    % ��ʼ�����ͼ��
    img_out = zeros(H, W, C, 'like', img);
    
    % ��ȡ�����ص�Ψһ��ǩ
    unique_labels = unique(Label);
    
    % ����ÿ��������
    for i = 1:length(unique_labels)
        % ��ȡ��ǰ�����ص�����
        mask = (Label == unique_labels(i));
        
        % ����ó����������ƽ����ɫ
        for c = 1:C
            % ��ȡ��ǰͨ�����ڸó����ص���������
            pixel_values = img(:,:,c);
            mean_value = mean(pixel_values(mask)); % �����ֵ
            
            % ��ֵ�����ͼ��
            img_out(:,:,c) = img_out(:,:,c) + uint8(mask) * mean_value;
        end
    end
end
