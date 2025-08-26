# Pol_ECTSP_GSEO

This is a repository about the paper: "Edge-constrained temporal superpixel segmentation and graph-structured energy optimization for PolSAR change detection".

## Introduction

Polarimetric Synthetic Aperture Radar (PolSAR) has emerged as a vital tool for dynamic surface monitoring, owing to its ability to precisely characterize land cover scattering properties. 
However, conventional PolSAR change detection methods predominantly rely on pixel- or region-level direct comparisons, rendering them sensitive to speckle noise and multi-temporal radiometric inconsistencies. 
In addition, existing superpixel generation algorithms typically neglect temporal information and edge strength, resulting in suboptimal segmentation accuracy.
To overcome these limitations, this paper introduces a novel edge-constrained temporal superpixel generation method. 
A new temporal polarimetric similarity metric is proposed to emphasize significant temporal variations, while an edge constraint mechanism is incorporated to prevent superpixels from crossing semantic boundaries, thereby improving segmentation fidelity.
Building upon the generated superpixels, we develop a graph-structured energy optimization framework for PolSAR change detection. 
In this framework, superpixels serve as the fundamental processing units to construct a topological representation that integrates both temporal feature similarity and spatial adjacency. 
A cross-node similarity metric is further designed to enhance the detection of weak scattering changes, and a global energy function is formulated to suppress noise while preserving the structural integrity of changed regions.

===================================================

## Datasets and Energy minimization algorithms

QPBO energy minimization algorithm is download from Professor Anton Osokin's webpage at https://github.com/aosokin/qpboMex.

LSA energy minimization algorithm is download from https://vision.cs.uwaterloo.ca/code/.

LPEM algorithm is download from https://github.com/yulisun/LPEM .

===================================================
## Citation

If you use this code for your research, please cite our paper. Thank you!

@article{LI202549,
title = {Edge-constrained temporal superpixel segmentation and graph-structured energy optimization for PolSAR change detection},
journal = {ISPRS Journal of Photogrammetry and Remote Sensing},
volume = {229},
pages = {49-64},
year = {2025},
issn = {0924-2716},
doi = {https://doi.org/10.1016/j.isprsjprs.2025.08.006},
url = {https://www.sciencedirect.com/science/article/pii/S092427162500317X},
author = {Nengcai Li and Deliang Xiang and Huaiyue Ding and Yuzhen Xie and Yi Su},
keywords = {Polarimetric Synthetic Aperture Radar (PolSAR), Temporal Superpixel Segmentation, Change detection, Edge constrain, Graph-structured optimization},
abstract = {Polarimetric Synthetic Aperture Radar (PolSAR) has emerged as a vital tool for dynamic surface monitoring, owing to its ability to precisely characterize land cover scattering properties. However, conventional PolSAR change detection methods predominantly rely on pixel- or region-level direct comparisons, rendering them sensitive to speckle noise and multi-temporal radiometric inconsistencies. In addition, existing superpixel generation algorithms typically neglect temporal information and edge strength, resulting in suboptimal segmentation accuracy. To overcome these limitations, this paper introduces a novel edge-constrained temporal superpixel generation method. A new temporal polarimetric similarity metric is proposed to emphasize significant temporal variations, while an edge constraint mechanism is incorporated to prevent superpixels from crossing semantic boundaries, thereby improving segmentation fidelity. Building upon the generated superpixels, we develop a graph-structured energy optimization framework for PolSAR change detection. In this framework, superpixels serve as the fundamental processing units to construct a topological representation that integrates both temporal feature similarity and spatial adjacency. A cross-node similarity metric is further designed to enhance the detection of weak scattering changes, and a global energy function is formulated to suppress noise while preserving the structural integrity of changed regions. Extensive experiments on five PolSAR datasets validate the superior performance of the proposed approach, demonstrating significant improvements in noise suppression, temporal feature representation, and change detection accuracy over existing state-of-the-art methods. Specifically, the proposed superpixel segmentation method achieves an average improvement of 6.62% in boundary recall and 1.46% in achievable segmentation accuracy compared to the TSPol-ASLIC algorithm. For the change detection task, the proposed framework achieves a peak overall accuracy of 0.9802, an F1-score of 0.9431, and a kappa coefficient of 0.9311, significantly outperforming conventional pixel-level approaches. The code will be available at https://github.com/linengcai/Pol_ECTSP_GSEO.}
}
