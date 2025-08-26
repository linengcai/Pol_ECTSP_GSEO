% �����ʼ�ķ��γ��������ķֲ�
% ����ͼ��ĳ��� m n �����صĳ߶�s
% �õ� ��״Ϊ h * w �ĳ�ʼ����������
 
function [rowC_init, colC_init] = InitSPCenterGrid(m, n, s)


    %--------����դ�񶥵������ĵ�����---------% 
    h = floor(m / s); % ���ж��ٸ�������
    w = floor(n / s); % ���ж��ٸ�������
    % �����ò����ı���
    rowR = floor((m - h*s)/2); % ���ಿ����β����
    colR = floor((n - w*s)/2);

    rowStartList=(rowR + 1) : s : (m - s + 1); % ������ �� ��ʼ ����
    rowStartList(1) = 1;
    rowEndList = rowStartList + s;  % ������ �� ���� ����
    rowEndList(1) = rowR + s;
    rowEndList(end) = m;
    colStartList = (colR + 1) : s : (n - s + 1);
    colStartList(1) = 1;
    colEndList = colStartList + s;
    colEndList(1) = colR + s;
    colEndList(end) = n;
    rowCList = floor((rowStartList + rowEndList - 1) / 2); % ������ �� ��������
    colCList = floor((colStartList + colEndList - 1) / 2);
    % ��ʾ���ֽ��
    if 0
        temp = zeros(m,n);
        temp(rowStartList,:)=1;
        temp(:,colStartList)=1;
        for i=1:h
            for j=1:w
                temp(rowCList(i), colCList(j))=1;
            end
        end
        figure,imshow(temp);
    end
    rowC_init = repmat(rowCList', [1,w]); 
    colC_init = repmat(colCList, [h,1]);


end