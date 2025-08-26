
function Label = DualTimePolSARSuperPixel(dataPath, image_t1, image_t2, realEdge, s, rs_scale, Flag_regeneEDGE)
%% edge detect
% ��Ե��⣬�Ѿ��оͲ��ظ�����
% Flag_regeneEDGE = 0;
EDGE_file = fullfile(dataPath, 'ESM.mat');
if exist(EDGE_file, 'file') == 2 && Flag_regeneEDGE == 0
    load(EDGE_file);
else
    %----- setting -------%
    Looks = 3;    % Looks
    direction = 8;  % directions
    Tlow = .1;     %  0.03 threshold
    Thigh = 0.6;  % 0.18
    thresh = [Tlow Thigh]; % ��������edgeMap����ֵ����

    w = 3;
    l = 3;
    wl = [w, l];
    alpha = 2; 
    sigx = (2*l+1)/(2*sqrt(pi)); % �ı�����ĵľۼ��̶�
    beta = w/(gamma(alpha)^2*2^(2*alpha-1)/gamma(2*alpha-1));
    sabeta = [sigx, alpha, beta];

    %----------- run ------------%
    tic
    [edgeMap, ESM] = DualPolSAR_EdgeDetect(image_t1, image_t2, thresh, sabeta, wl, direction, Looks);
    toc

    %-----  save  -------%
    save(fullfile(dataPath, 'ESM.mat'), 'ESM');
end

% ��һ��
ESM = ESM ./ (mean(ESM(:) * 3));
ESM = min(ESM, 1);

ESM_tmp = uint8(255 * ESM);
ESM_tmp = cat(3, ESM_tmp, ESM_tmp, ESM_tmp);


highlightedESM(:,:,1) = ESM_tmp(:,:,1) + uint8(255 * realEdge);  % ���Ӻ�ɫͨ��
highlightedESM(:,:,2) = ESM_tmp(:,:,2) .* uint8(~realEdge);       % ������ɫͨ��
highlightedESM(:,:,3) = ESM_tmp(:,:,3) .* uint8(~realEdge);       % ������ɫͨ��

global HESM;

HESM = double(highlightedESM(:,:,1))/255;

figure;
subplot(131);imshow(ESM);title('ESM')
subplot(132);imshow(highlightedESM);title('highlightedESM')
subplot(133);imshow(HESM);title('HESM')



%% Dual Time SuperPixel
Label = DualTimeSPFunction(image_t1, image_t2, ESM, s, rs_scale);

















