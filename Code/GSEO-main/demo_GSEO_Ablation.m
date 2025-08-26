% clc
clear all
close all

addpath(genpath(pwd))


s_list = [8,10,12,15,18];

% There are seven datasets in total, but this demo only provides dataset #2.
dataset = 'dataset#2';
Load_dataset 
fprintf([dataset ' loading is completed...... ' '\n'])

%% Parameter setting
% With different parameter settings, the results will be a little different
%--------------------Available datasets and Parameters---------------------
par.dataset = dataset;
par.alpha = 1.2;  % [0.8 - 1.5]
par.SolutionMethod = 'QPBO'; % QPBO or LSA

for j = 2
    % default s = 10
    par.s = s_list(j);
    par

    %% make dir
    sp_result_path = fullfile(dataPath, 'sp_result_path');
    if ~exist(sp_result_path, 'dir')
        % 如果不存在，则创建文件夹
        mkdir(sp_result_path);
    end
    CD_result_path = fullfile(dataPath, 'CD_result_path');
    if ~exist(CD_result_path, 'dir')
        % 如果不存在，则创建文件夹
        mkdir(CD_result_path);
    end


    %% DualTime Superpixel generation
    Flag_regeneSP = 0; % 0 indicates that if the file already exists, it will not be regenerated.
    SP_file = fullfile(sp_result_path, ['Proposed_' 'SPLabel_' num2str(par.s) '.mat']);
    if exist(SP_file, 'file') == 2 && Flag_regeneSP == 0
        load(SP_file);
        % Metrics
        BR = CalBR2(Label, Ref_gt);
        ASA = CalASA2(Label, Ref_gt);
    else
        Flag_regeneEDGE = 0; % 0 indicates that if the file already exists, it will not be regenerated.
        rs_scale = 1.; % 搜索范围增加多少
        Label = DualTimePolSARSuperPixel(sp_result_path, image_t1, image_t2, realEdge, par.s, rs_scale, Flag_regeneEDGE);
        % Metrics
        BR = CalBR2(Label, Ref_gt);
        ASA = CalASA2(Label, Ref_gt);
        save(SP_file, 'Label', 'BR', 'ASA');
    end

    % 绘制
    if 1
        outputImage1 = draw_superpixel_edges(img_pauli1, Label);
        outputImage2 = draw_superpixel_edges(img_pauli2, Label);
        figure;
        subplot(131);imshow(outputImage1);title('imaget1')
        subplot(132);imshow(outputImage2);title('imaget2')
        subplot(133);imshow(Ref_gt,[]);title('Refgt')    
    end

    %% GSEO
    fprintf(['\n GSEO is running...... ' '\n'])
    time = clock;
    [CM,labels,Cosup] = GSEO_main_PTD(image_t1_PTD, image_t2_PTD, Label, par, Ref_gt);


    fprintf('\n');fprintf('The total computational time of GSEO using %s is %i \n', par.SolutionMethod,etime(clock,time));
    fprintf(['\n' '====================================================================== ' '\n'])


    %%
    overlay_img1 = overlay_change_map(img_pauli1, CM);
    overlay_img2 = overlay_change_map(img_pauli2, CM);
    figure;
    subplot(121);imshow(overlay_img1);title('Change map')
    subplot(122);imshow(overlay_img2);title('Ground truth')

    overlay_img1 = overlay_change_map(img_pauli1, Ref_gt);
    overlay_img2 = overlay_change_map(img_pauli2, Ref_gt);
    figure;
    subplot(121);imshow( overlay_img1);title('Change map')
    subplot(122);imshow(overlay_img2);title('Ground truth')

    %% Displaying results
    fprintf(['\n Displaying the results...... ' '\n'])
    figure;
    subplot(131);imshow(CM);title('Change map')
    subplot(132);imshow( CMplotRGB(CM,Ref_gt));title('Change map')
    subplot(133);imshow(Ref_gt,[]);title('Ground truth')


    [tp,fp,tn,fn,fplv,fnlv,~,~,OA,kappa]=performance(CM,Ref_gt);
    F1 = 2*tp/(2*tp+fp+fn);
    result = 'GSEO: OA is %4.4f; Kc is %4.4f; F1 is %4.4f \n';
    fprintf(result,OA,kappa,F1)

    %% 保存实验结果
    CM_path = fullfile(CD_result_path, [dataset '_s_' num2str(par.s) '_CM.png']);
    CMRGB_path = fullfile(CD_result_path, [dataset '_s_' num2str(par.s) '_CMRGB.png']);
    imwrite(CM, CM_path);
    imwrite(CMplotRGB(CM,Ref_gt), CMRGB_path);

end




