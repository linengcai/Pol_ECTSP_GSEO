% ������һ���������� E(x) = c' * x + x' * Q * x������ c ������ϵ����Q �Ƕ�����ϵ������
% ���������Ŀ
N = 10;

% �����ʼ�������� c �Ͷ�����ϵ������ Q
c = rand(N, 1);
Q = rand(N, N);

% ����ͼ�ı�Ȩ�ؾ���
% ������ת��ΪԴ�ͻ������Ȩ��
source_weights = max(0, c); % �� c ת��Ϊ���ӵ�Դ��Ȩ��
sink_weights = max(0, -c);  % �� -c ת��Ϊ���ӵ����Ȩ��

% ������ת��Ϊͼ�еı�Ȩ��
edge_weights = abs(Q);

% ʹ�� QPBO ������������α�����Ż���
labels = QPBO(source_weights, sink_weights, edge_weights);

% �����
disp('QPBO�����ǩ��');
disp(labels);
