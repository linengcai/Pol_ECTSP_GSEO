function [edge_map, ESM] = DualPolSAR_EdgeDetect(img1, img2, thresh, sabeta, wl, direction, Looks)
% img: input PolSAR image
% thresh: a vector of [lowT, highT], and 0< lowT < highT < 1;

thresh0 = .1;
thresh1 = .1;
thresh2 = .2;
sab = [3 2 2];
% rou2 = 2; sigma2 = 2;
directions = 8;

if nargin > 1
    thresh0 = thresh(1);
    thresh1 = thresh(1);
    thresh2 = thresh(2);
    if nargin > 2
        sab = sabeta;
        if nargin > 3
            directions = direction;
        end
    end
end

filterWindowSize = ceil(sqrt((wl(1) + 1)^2 + wl(2)^2));

%------------ Compute CFAR edge map for PolSAR data using GG window----------

% look = 13;
[ESM_R, index1, index2] = DualPolSAR_GausGamma_Filter(img1, img2, sab, filterWindowSize, directions, Looks);


%%
ESM = ESM_R;
% figure, imshow(ESM_R,[])
% figure, imshow(index, [])
%--------------------------------------------
edgeMap_0 = non_maximum_suppression_multidirection(ESM, index1, thresh0, 1, directions);

% % %-----extract edge map
edge_possible = (ESM>thresh1).*edgeMap_0;
edge_strong = (ESM>thresh2).*edgeMap_0;
[xs, ys] = find(edge_strong == 1);
edge_map = bwselect(edge_possible, ys, xs, 8);
edge_map = bwmorph(edge_map, 'thin',8);
edge_map = edge_map(filterWindowSize+1:end-filterWindowSize, filterWindowSize+1:end-filterWindowSize);
ESM = ESM(filterWindowSize+1:end-filterWindowSize, filterWindowSize+1:end-filterWindowSize);
% figure, imshow(x, [])
% figure, imshow(edge_map, [])