function [CM,bi_map,Cosup] = GSEO_main_PTD(image_t1, image_t2, Cosup, par, Ref_gt)

%-------------  Preprocessing---------------%
[t1_feature, t2_feature] = PTDfeatureExtraction(Cosup, image_t1, image_t2);



%%
Kmax = round(size(t1_feature, 2).^0.5);
% Kmax = 20;
Kmin = round(Kmax / 10);
[Kmat_x] = adaptiveKmat(t1_feature, Kmax, Kmin); % 每个样本的邻居数目,再Kmax和Kmin之间
[Kmat_y] = adaptiveKmat(t2_feature, Kmax, Kmin);

Kmat_xy = [Kmat_x Kmat_y]; % adaptive k
Kmat_xy = Kmax * ones(size(Kmat_xy));

%-------------  Hybrid energy construction---------------%
EdgeWeights = PTDEnergyConstruction(Cosup, par, t1_feature, t2_feature, Kmat_xy, Ref_gt);

Esp_termWeights = zeros(size(t1_feature, 2), 2); 
Esp_termWeights(:, 2) = 1;

EdgeWeights(EdgeWeights(:,1) == EdgeWeights(:,2), :) = [];

%%
%-------------  Energy minimization using QPBO or LSA ------------%
% QPBO is faster than LSA, but not as robust as LSA!

if strcmp(par.SolutionMethod,'QPBO') == 1
%     addpath('qpboMex');
    [~, labels_qpbo] = qpboMex(Esp_termWeights, EdgeWeights);
    idx_co = label2idx(Cosup);
    for i = 1:size(t1_feature,2)
        index_vector = idx_co{i};
        bi_map(index_vector) = labels_qpbo(i);
    end
%     bi_map(find(bi_map~=0))=1;
    CM =reshape(bi_map,[size(Cosup,1) size(Cosup,2)]);
elseif strcmp(par.SolutionMethod,'LSA') == 1
%     addpath('LSA_TR_v2.03');addpath('LSA_TR_v2.03\bk_matlab')
    [energy.UE, energy.subPE, energy.superPE, energy.constTerm] = reparamEnergy(Esp_termWeights', final_edgeWeights);
    [labels_LSA, E, iteration] = LSA_TR(energy);
    idx_co = label2idx(Cosup);
    for i = 1:size(t1_feature,2)
        index_vector = idx_co{i};
        bi_map(index_vector) = 2-labels_LSA(i);
    end
    CM = reshape(bi_map,[size(Cosup,1) size(Cosup,2)]);
end

