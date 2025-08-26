%% There are seven datasets in total, but this demo only provides dataset #2. 

if strcmp(dataset,'dataset#1') == 1 
    dataPath = '.\Data\ALOS2_SAN_1\ROI_1';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';
    opt.type_t2 = 'polsar';
elseif strcmp(dataset,'dataset#2') == 1 
    dataPath = '.\Data\ALOS2_SAN_1\ROI_2';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';
    opt.type_t2 = 'polsar';
elseif strcmp(dataset,'dataset#3') == 1 
    dataPath = '.\Data\ALOS2_SAN_1\ROI_3';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';
    opt.type_t2 = 'polsar';   
elseif strcmp(dataset,'dataset#4') == 1 
    dataPath = '.\Data\UAVSAR_LOS_1\ROI_1';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';
    opt.type_t2 = 'polsar'; 
elseif strcmp(dataset,'dataset#5') == 1 
    dataPath = '.\Data\UAVSAR_LOS_1\ROI_2';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';% the SAR image has been Log transformed
    opt.type_t2 = 'polsar';
elseif strcmp(dataset,'dataset#6') == 1
    dataPath = './Data/UAVSAR_LOS_2/ROI_1';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';
    opt.type_t2 = 'polsar';
elseif strcmp(dataset,'dataset#7') == 1 
    dataPath = './Data/UAVSAR_LOS_2/ROI_2';
    load(fullfile(dataPath, 'dataset.mat'));
    opt.type_t1 = 'polsar';
    opt.type_t2 = 'polsar';
end

image_t1 = filterTorC(image_t1, 3);
image_t2 = filterTorC(image_t2, 3);


%% plot images
img_pauli1 = fPauliImShow(image_t1);
highlightedImg1(:,:,1) = img_pauli1(:,:,1) + uint8(255 * realEdge);  % 增加红色通道
highlightedImg1(:,:,2) = img_pauli1(:,:,2) .* uint8(~realEdge);       % 减少绿色通道
highlightedImg1(:,:,3) = img_pauli1(:,:,3) .* uint8(~realEdge);       % 减少蓝色通道

img_pauli2 = fPauliImShow(image_t2);
highlightedImg2(:,:,1) = img_pauli2(:,:,1) + uint8(255 * realEdge);  % 增加红色通道
highlightedImg2(:,:,2) = img_pauli2(:,:,2) .* uint8(~realEdge);       % 减少绿色通道
highlightedImg2(:,:,3) = img_pauli2(:,:,3) .* uint8(~realEdge);       % 减少蓝色通道

% Pauli Decomposition
image_t1_PTD = image_t1(:,:,1:3);
image_t2_PTD = image_t2(:,:,1:3);


