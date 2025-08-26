function BR = CalBR2(L, GT)
    % ���� L �ǳ����ر�ǩͼ��GT ����ʵ�ķָ�ͼ
    % L �� GT �Ĵ�СӦ��ͬ

    % ���㳬���صı߽�����
    boundaryL = boundarymask(L);

    % ������ʵ�ָ�ı߽�����
    boundaryGT = boundarymask(GT);

    % ���þ�����ֵ
    maxDistance = 2; % ���Ը�����Ҫ����

    % ʹ�� bwdist ����ÿ���߽����ص������߽����С����
    distancesToGT = bwdist(boundaryL);

    % ����Ԥ��߽����Чƥ��
    matchedBoundaries = distancesToGT <= maxDistance & boundaryGT;

    % ������ʵ�߽������
    numGTBoundaries = sum(boundaryGT(:));

    % ����ƥ��ı߽���
    numMatchedBoundaries = sum(matchedBoundaries(:));

    % ���� Boundary Recall (BR)
    BR = numMatchedBoundaries / numGTBoundaries;

    fprintf('Boundary Recall (BR): %.4f\n', BR);

end