function [Kmat] = adaptiveKmat(X,kmax,kmin)
X = X';
kmax = kmax+1;
% [idx, distX] = knnsearch(X,X,'k',kmax);
% ���ܲ��޸�
[idx, distX] = customKNN(X,X,kmax);

[N,Dx] = size(X);
% ʹ�� tabulate ͳ�� idx ��ÿ�������������������ھ��б��г��ֵĴ���������¼������������������Ϊ�ھӵ�Ƶ��
% ��һ�У�ÿ��������������
% �ڶ��У���Ӧ���������������ھ��б��г��ֵĴ�����
% �����У�����Ƶ�ʵİٷֱȣ������ݲ�ʹ�ã���
degree_x = tabulate(idx(:));
Kmat = degree_x(:,2);
Kmat(Kmat >= kmax)=kmax;
Kmat(Kmat <= kmin)=kmin;
if length(Kmat) < N
    Kmat(length(Kmat)+1:N) = kmin;
end
