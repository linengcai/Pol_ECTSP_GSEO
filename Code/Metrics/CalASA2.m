
function ASA = CalASA2(Label, GT)

    % ��ȡͼ��Ĵ�С
    [rows, cols] = size(Label);

    % ��ȡΨһ�ĳ����ر�ǩ��Ŀ
    uniqueSuperpixels = unique(Label);
    numSuperpixels = length(uniqueSuperpixels);

    % ��ʼ����ȷ���ؼ���
    correctPixels = 0;

    % ����ÿ��������
    for i = 1:numSuperpixels
        % �ҵ�ÿ�������ص���������
        superpixelMask = (Label == uniqueSuperpixels(i));

        % ��ȡ��ǰ��������������ʵ�ָ�ı�ǩ
        gtLabels = GT(superpixelMask);

        % �ҵ��ó���������������������ʵ��ǩ�������������Ҫ���
        majorityLabel = mode(gtLabels);

        % ����ó���������������ʵ��ǩƥ���������
        correctPixels = correctPixels + sum(gtLabels == majorityLabel);
    end

    % ������������
    totalPixels = rows * cols;

    % ���� ASA
    ASA = correctPixels / totalPixels;

    fprintf('Average Segmentation Accuracy (ASA): %.4f\n', ASA);
end