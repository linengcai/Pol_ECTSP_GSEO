function [indices, distances] = customKNN(X, Y, k)
    % X: ѵ�����ݼ���ÿ����һ������
    % Y: �������ݼ���ÿ����һ������
    % k: KNN �е� k ֵ
    % distanceFunc: �Զ�����뺯����� (�� @euclideanDistance �� @manhattanDistance)
    % indices: ÿ��������������� k ���ھ���ѵ�����е�����
    % distances: ÿ��������������� k ���ھӵľ���
    
    numTest = size(Y, 1);     % ���Լ���������
    numTrain = size(X, 1);    % ѵ������������
    indices = zeros(numTest, k);    % ��ʼ�������������
    distances = zeros(numTest, k);  % ��ʼ������������
    
    % ����ÿ����������
    for i = 1:numTest
        currentDistances = zeros(numTrain, 1); % ��ǰ����������ÿ��ѵ�������ľ���
        
        % ���㵱ǰ��������������ѵ�������ľ���
        for j = 1:numTrain
%             currentDistances(j) = featureDist(Y(i, :), X(j, :));
            currentDistances(j) = featureDistPTD(Y(i, :), X(j, :));
        end
        
        % �ҵ���������� k ���ھ�
        [sortedDistances, sortedIndices] = sort(currentDistances);
        indices(i, :) = sortedIndices(1:k);      % ����� k ���ھӵ�����
        distances(i, :) = sortedDistances(1:k);  % ����� k ���ھӵľ���
    end
end

% ʾ�����뺯����ŷ����þ���
function d = euclideanDistance(x1, x2)
    d = sqrt(sum((x1 - x2).^2));
end

% ʾ�����뺯���������پ���
function d = manhattanDistance(x1, x2)
    d = sum(abs(x1 - x2));
end
