function edgeMap = non_maximum_suppression_multidirection(ESM, index, thresh, widthw, directions)
% ESM:��Եǿ��ӳ��
% index:ÿ����Եǿ��ӳ���Ӧ�ķ���
%
% edgeMap:��Եӳ��
width = 1;
N = directions;
if nargin >= 4
    width = widthw;
    if nargin >= 5
        N = directions;
    end
end

[rows, cols] = size(ESM);
edgeMap = zeros(rows, cols);
theta = 0:pi/N:pi-pi/N;
% width = 3;
% p1 = [0 width];
% p2 = [0 -width];
p1 = [width 0];
p2 = [-width 0];
for m = 1+width : rows-width
    for n = 1+width:cols-width
        alpha = -theta(index(m,n));
        x1 = round(p1(1) * cos(alpha) + p1(2) * sin(alpha));
        y1 = round(-p1(1) * sin(alpha) + p1(2) * cos(alpha));
        x2 = round(p2(1) * cos(alpha) + p2(2) * sin(alpha));
        y2 = round(-p2(1) * sin(alpha) + p2(2) * cos(alpha));
        if ESM(m,n)>thresh && ESM(m,n)>ESM(m+x1, n+y1) && ESM(m,n)>ESM(m+x2,n+y2)
            edgeMap(m,n) = 1;
        end
    end
end