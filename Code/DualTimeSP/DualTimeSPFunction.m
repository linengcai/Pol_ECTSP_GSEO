function Label = DualTimeSPFunction(image_t1, image_t2, edge, s, rs_scale)

% ��һ��Span
span1 = image_t1(:,:,1) + image_t1(:,:,2) + image_t1(:,:,3);
span2 = image_t2(:,:,1) + image_t2(:,:,2) + image_t2(:,:,3);
spanmax = min(max([span1(:);span2(:)]), mean([span1(:);span2(:)]) * 2) ;
span1 = min(1, span1 ./ spanmax);
span2 = min(1, span2 ./ spanmax);


%% �����ʼ����������
m = size(image_t1, 1); % �� 
n = size(image_t1, 2); % ��

% �õ����ηֲ�
[rowC_init, colC_init] = InitSPCenterGrid(m, n, s);

[h, w] = size(rowC_init);

rowC = reshape(rowC_init, h*w, 1);
colC = reshape(colC_init, h*w, 1);
regionSizeC = ones(size(rowC)) * s;


lenSP = length(rowC);

% ����һ����ʼ�ĳ��������ģ�����ȷ��������Χ
rowC_init = rowC;
colC_init = colC;

% ��ʼ���������ķ����ڱ�Եǿ�ȵ�
for i = 1 : lenSP
    % 3*3��block
    block = edge(rowC(i) - 1 : rowC(i) + 1, colC(i) - 1 : colC(i) + 1);
    [minVal, idxArr] = min(block(:));
    % ����С��edge������
    jOffset = floor((idxArr(1) + 2) / 3);
    iOffset = idxArr(1) - 3 * (jOffset - 1);
    rowC(i) = rowC(i) + iOffset - 2;
    colC(i) = colC(i) + jOffset - 2;
end

%%  kmeans�����طָ�
M1 = reshape(image_t1, m * n, size(image_t1, 3));  % ����ֵ���� matlab����ά���ݴ������
M2 = reshape(image_t2, m * n, size(image_t2, 3));
Label = zeros(m, n) - 1; % ��ǩ
dist = Inf * ones(m, n); % ÿ�����ص���С����

% �����ʼ����
colorCenter = zeros(lenSP, size(image_t1, 3) * 2);
SpanCenter = zeros(lenSP, 2);
for i = 1 : lenSP
    colorCenter(i, 1:9) = image_t1(rowC(i), colC(i), :);
    colorCenter(i, 10:18) = image_t2(rowC(i), colC(i), :);
    SpanCenter(i, 1) = span1(rowC(i), colC(i), :);
    SpanCenter(i, 2) = span2(rowC(i), colC(i), :);
end
Centers = cat(2, colorCenter, SpanCenter, rowC, colC); % �ڵ�2ά ƴ�ӵ�һ��

% ��ʼѭ��
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
    % ���ճ����ظ�������ѭ��
    for k = 1 : lenSP
        rowCidx = Centers(k, 21);
        colCidx = Centers(k, 22); %������������
        rs = round(regionSizeC(k) * rs_scale);
        rowStart = max(1, rowC_init(k) - rs);
        rowEnd = min(m, rowC_init(k) + rs);
        colStart = max(1, colC_init(k) - rs);
        colEnd = min(n, colC_init(k) + rs);
        
        colorC1 = Centers(k, 1:9);
        colorC2 = Centers(k, 10:18);
        
        spanC1 = Centers(k, 19);
        spanC2 = Centers(k, 20);
        
        % ѭ������block
        for i = rowStart : rowEnd
            for j = colStart : colEnd
                
                colorCur1 = M1((j - 1) * m + i, :);
                colorCur2 = M2((j - 1) * m + i, :);
                
                dW1 = Cal_JBLD2(colorCur1, colorC1); % ʵ�������÷���
                dW2 = Cal_JBLD2(colorCur2, colorC2);
                
                
                dW = 1 * max(dW1, dW2);
                if dW > 2.5
                    dW = 2.5;
                end
                
                dS = 1 * sqrt((i - rowCidx)^2 + (j - colCidx)^2) / rs * rs_scale; % �ó�������Ȼ����ԭ��s�Ľ��¶�
                
                dT1 = abs(spanC1 - span1(i, j)) ./ max(spanC1, span1(i, j));
                dT2 = abs(spanC2 - span2(i, j)) ./ max(spanC2, span2(i, j)); % �ٷֱ����
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
        % ����
        Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label);
    end
    
    % ��������
    Centers = UpdateCenter(Label, rowC_init, colC_init, regionSizeC, rs_scale, M1, M2, span1, span2);
    
    % early stop
    diff = Centers(:,21:22) - Centers_last(:,21:22);
%     disp(sum(abs(diff(:))))
    if sum(abs(diff(:))) < lenSP / 9 %�в������ֵ����������
        disp(sum(abs(diff(:))));
        break;
    end
    
    if 0
        % �����߽�����
        Boundary = boundarymask(Label);
        % ��ʾԭͼ��ʹ���ǩ��ͼ��
        figure;
        subplot(1,2,1);
        imshow(imoverlay(img_pauli1, Boundary, 'red')); % ԭͼ�ϵ��ӱ߽�
        subplot(1,2,2);
        imshow(imoverlay(img_pauli2, Boundary, 'red')); % ԭͼ�ϵ��ӱ߽�
        title('ԭͼ�볬���ر߽����');
    end
end

% ����
Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label);











