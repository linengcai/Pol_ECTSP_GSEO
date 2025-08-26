function [ESM, index1, index2] = DualPolSAR_GausGamma_Filter(img1, img2, sab, lf, directions, looks)

% img: 原图像
% lf: windows size
% ESM: 边缘映射
% index: 每一点对应的最小比率方向

% sigx = sab(1);
% alpha = sab(2);
% beta = sab(3);
% sigy = sab(4);

img_mean1 = img1;
img_mean2 = img2;

expan_img1 = ExpanMatrix(img_mean1, lf);
expan_img2 = ExpanMatrix(img_mean2, lf);

[expanRow, expanCol] = size(expan_img1(:,:,1));

% cta = 0:pi/directions:pi-pi/directions;
Dist = zeros(expanRow, expanCol, directions, 2);

for p = 1:directions
	% 生成window
    [upperW, lowerW] = GausGamma_Window_PolSAR(sab, lf, 0, p, directions, 2);
%     window = upperW + lowerW;
%     [upperW, lowerW] = gaus_gamma_window(sab, lf, p);
%     [upperW,lowerW]=bi_window(xx,xx,df,wf,lf,cta(p));
    
    % img1 Upper
    C11U1=filter2(upperW,expan_img1(:,:,1),'same');
    C22U1=filter2(upperW,expan_img1(:,:,2),'same');
    C33U1=filter2(upperW,expan_img1(:,:,3),'same');
    C12rU1=filter2(upperW,expan_img1(:,:,4),'same');
    C13rU1=filter2(upperW,expan_img1(:,:,5),'same');
    C23rU1=filter2(upperW,expan_img1(:,:,6),'same');
    C12iU1=filter2(upperW,expan_img1(:,:,7),'same');
    C13iU1=filter2(upperW,expan_img1(:,:,8),'same');
    C23iU1=filter2(upperW,expan_img1(:,:,9),'same');
    
    % img1 Lower
    C11L1=filter2(lowerW,expan_img1(:,:,1),'same');
    C22L1=filter2(lowerW,expan_img1(:,:,2),'same');
    C33L1=filter2(lowerW,expan_img1(:,:,3),'same');
    C12rL1=filter2(lowerW,expan_img1(:,:,4),'same');
    C13rL1=filter2(lowerW,expan_img1(:,:,5),'same');
    C23rL1=filter2(lowerW,expan_img1(:,:,6),'same');
    C12iL1=filter2(lowerW,expan_img1(:,:,7),'same');
    C13iL1=filter2(lowerW,expan_img1(:,:,8),'same');
    C23iL1=filter2(lowerW,expan_img1(:,:,9),'same');
    
    % img2 Upper
    C11U2=filter2(upperW,expan_img2(:,:,1),'same');
    C22U2=filter2(upperW,expan_img2(:,:,2),'same');
    C33U2=filter2(upperW,expan_img2(:,:,3),'same');
    C12rU2=filter2(upperW,expan_img2(:,:,4),'same');
    C13rU2=filter2(upperW,expan_img2(:,:,5),'same');
    C23rU2=filter2(upperW,expan_img2(:,:,6),'same');
    C12iU2=filter2(upperW,expan_img2(:,:,7),'same');
    C13iU2=filter2(upperW,expan_img2(:,:,8),'same');
    C23iU2=filter2(upperW,expan_img2(:,:,9),'same');
    
    % img2 Lower
    C11L2=filter2(lowerW,expan_img2(:,:,1),'same');
    C22L2=filter2(lowerW,expan_img2(:,:,2),'same');
    C33L2=filter2(lowerW,expan_img2(:,:,3),'same');
    C12rL2=filter2(lowerW,expan_img2(:,:,4),'same');
    C13rL2=filter2(lowerW,expan_img2(:,:,5),'same');
    C23rL2=filter2(lowerW,expan_img2(:,:,6),'same');
    C12iL2=filter2(lowerW,expan_img2(:,:,7),'same');
    C13iL2=filter2(lowerW,expan_img2(:,:,8),'same');
    C23iL2=filter2(lowerW,expan_img2(:,:,9),'same');
    
    for i = 1:expanRow
        for j = 1:expanCol
            %% 先进行分解 然后重构 然后求距离
            % img1 的 上 下
            Zx1 = [C11U1(i, j), C22U1(i, j), C33U1(i, j), C12rU1(i, j), C13rU1(i, j), C23rU1(i, j), C12iU1(i, j), C13iU1(i, j), C23iU1(i, j)];
            Zy1 = [C11L1(i, j), C22L1(i, j), C33L1(i, j), C12rL1(i, j), C13rL1(i, j), C23rL1(i, j), C12iL1(i, j), C13iL1(i, j), C23iL1(i, j)];
            % img2 的 上 下
            Zx2 = [C11U2(i, j), C22U2(i, j), C33U2(i, j), C12rU2(i, j), C13rU2(i, j), C23rU2(i, j), C12iU2(i, j), C13iU2(i, j), C23iU2(i, j)];
            Zy2 = [C11L2(i, j), C22L2(i, j), C33L2(i, j), C12rL2(i, j), C13rL2(i, j), C23rL2(i, j), C12iL2(i, j), C13iL2(i, j), C23iL2(i, j)];


            
            Dist(i,j,p,1) = CalJBLD(Zx1, Zy1);
            Dist(i,j,p,2) = CalJBLD(Zx2, Zy2);
       
        end
    end
    % replace the nan values with 1e4
%     Dist(isnan(Dist)) = 1e4;    

    disp([ 'processed ' num2str(p) ' direction']); 
end

% Dist = 1 - Dist;
% Dist = Dist + 1;
% Dist = min(Dist, 2.5);

[tmp, index1] = max(Dist, [], 3);
[ESM, index2] = max(tmp, [], 4);

% [ESM, index] = min(Dist,[],3);
% ESM=1-ESM;

