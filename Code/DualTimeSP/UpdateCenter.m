% ���� rowC_init colC_init regionSizeC ��ȷ����������
% M1 M2 span1 span2 ������ƽ��ֵ��ȷ�������ĵ������
function Centers = UpdateCenter(Label, rowC_init, colC_init, regionSizeC, rs_scale, M1, M2, span1, span2)

    lenSP = length(rowC_init);
    [m, n] = size(span1);
    % ���¾�������
    colorCenter = zeros(lenSP, 9 * 2);
    SpanCenter = zeros(lenSP, 2);
    rowC = zeros(lenSP, 1);
    colC = zeros(lenSP, 1);

    for k = 1 : lenSP
        num = 0;
        sumColor = zeros(1, 18);    
        sumR = 0;
        sumC = 0;
        sumSpan = zeros(1, 2);
        rs = round(regionSizeC(k) * rs_scale);
        rowStart = max(1, rowC_init(k) - rs);
        rowEnd = min(m, rowC_init(k) + rs);
        colStart = max(1, colC_init(k) - rs);
        colEnd = min(n, colC_init(k) + rs);

        for i = rowStart:rowEnd
            for j = colStart:colEnd
                if Label(i, j) == k
                    % ����ƽ�������꣬����
                    num = num + 1;
                    sumR = sumR + i;
                    sumC = sumC + j;
                    color1 = M1((j - 1) * m + i, :);
                    color2 = M2((j - 1) * m + i, :);
                    color = cat(2, color1, color2);
                    sumColor = sumColor + color;
                    sumSpan(1) = sumSpan(1) + span1(i, j);
                    sumSpan(2) = sumSpan(2) + span2(i, j);
                end
            end
        end

        colorCenter(k, :) = sumColor / num;
        rowC(k) = sumR / num;
        colC(k) = sumC / num;
        SpanCenter(k, :) = sumSpan / num;

    end
    Centers = cat(2, colorCenter, SpanCenter, rowC, colC); % �ڵ���ά ƴ�ӵ�һ��    

end



% end