% ���� ��̬ѧ����
% ���� rowC_init colC_init regionSizeC ��ȷ����������
function Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label)
% ����Ƭ��
[m, n] = size(Label);
lenSP = length(rowC_init);
for k = 1 : lenSP
    % �޸�ΪĿǰ��������Ϊ���ĵ�դ��
    rs = round(regionSizeC(k) * rs_scale);
    rowStart = max(1, rowC_init(k) - rs);
    rowEnd = min(m, rowC_init(k) + rs);
    colStart = max(1, colC_init(k) - rs);
    colEnd = min(n, colC_init(k) + rs);

    % ��ȡ�����ص�block
    block = Label(rowStart:rowEnd, colStart:colEnd);
    block(block ~= k) = 0;
    block(block == k) = 1;
    [label, szlabel] = bwlabel(block, 4); % ��һ��0��1��ͼ��������ͨ���ͼ
    bh = rowEnd - rowStart + 1;
    bw = colEnd - colStart + 1;  %block�Ŀ��
    %�ް�����ͨ���Թ�
    if szlabel < 2  
        continue;
    end

    % �ҵ�������ͨ����Ϊ����ͨ����
    maxLen = -1;
    labelC = 1;
    for j = 1:szlabel
        tmpaa = find(label == j);
        if maxLen < length(tmpaa)
            maxLen = length(tmpaa);
            labelC = j;
        end
    end

    top = max(1, rowStart - 1);
    bottom = min(m, rowEnd + 1);
    left = max(1, colStart - 1);
    right = min(n, colEnd + 1);
    for i = 1 : szlabel %������ͨ��
        if i == labelC %����ͨ�򲻴���
            continue;
        end

        marker = zeros(bottom - top + 1, right - left + 1); %����һ������һȦ��marker�������Щ���Ѿ���ͳ�ƹ��Ӵ����
        bw = label;
        bw(bw ~= i) = 0;
        bw(bw == i) = 1; %��ǰ��ͨ����ͼ
        contourBW = bwperim(bw); %��ȡ������
        idxArr = find(contourBW == 1);
        labelArr = zeros(4 * length(idxArr), 1);  %��¼�������4�������ֵ������
        num = 0;
        for idx = 1 : size(idxArr) %����������,ͳ����4�����ı��ֵ
            bc = floor((idxArr(idx) - 1) / bh) + 1;
            br = idxArr(idx) - bh * (bc - 1); %��������block�е�������Ϣ
            row = br + rowStart - 1;
            col = bc + colStart - 1; %�������ڴ�ͼ�е�������Ϣ
            rc = [row - 1, col; row + 1, col; row, col - 1; row, col + 1];
            for p = 1 : 4
                row = rc(p, 1);
                col = rc(p, 2);

                if ~(row >= 1 && row <= m && col >= 1 && col <= n && Label(row, col) ~= k)
                    continue;
                end

                if marker(row - top + 1, col - left + 1) == 0 %δ��ͳ�ƹ�
                    marker(row - top + 1, col - left + 1) = 1;
                    num = num + 1;
                    labelArr(num) = Label(row, col);
                end
            end
        end

        labelArr(labelArr == 0) = []; %ȥ����Ԫ��
        uniqueLabel = unique(labelArr);
        numArr = zeros(length(uniqueLabel), 1);
        for p = 1 : length(uniqueLabel)
            idx = find(labelArr == uniqueLabel(p));
            numArr(p) = length(idx);
        end
        idx = find(numArr == max(numArr));
        maxnumLabel = uniqueLabel(idx(1)); %�Ӵ����ı�ǩ

        for row = rowStart : rowEnd
            for col = colStart : colEnd
                if bw(row-rowStart+1, col-colStart+1) == 0
                    continue;
                end
                Label(row, col) = maxnumLabel;
            end
        end
    end
end