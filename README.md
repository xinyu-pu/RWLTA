# Robust Weighted Low-Rank Tensor Approximation for Multiview Clustering With Mixed Noise
---

<p align="center">Readme for RWLTA</p>
<p align="center">version Dec. 22, 2023</p>

---

# About the robustness experiments
The algorithms for feature extraction and noise addition used in the section of the experiments can be found in the repository [image_feature_intensity_LBP_Gabor](https://github.com/xinyu-pu/image_feature_intensity_LBP_Gabor.git)

## Brief introduction
This repository includes the MATLAB code of the paper [X. Pu, H. Che, B. Pan, M. -F. Leung and S. Wen, "Robust Weighted Low-Rank Tensor Approximation for Multiview Clustering With Mixed Noise," in IEEE Transactions on Computational Social Systems, doi: 10.1109/TCSS.2023.3331366](https://doi.org/10.1109/TCSS.2023.3331366)

You will find an example of using this code in the repository *(Demo_bbcsport.d, Demo_bbc4.m, Demo_msrc.m)* and the corresponding datasets *(bbcsport.mat, BBC.mat, msrc.mat)*

## Recommended operating environment
MATLAB R2022a, Windows 10, 2.90-4.20 GHz AMD R7-4800H CPU, and 32 GB main memory.

### Parameter tuning tips:
- For $w$, we suggest it based on a priori knowledge, specifically, the range of $w_i$ can be set as $[0.1, 10]$. We suggest select $\lambda_1$, $\lambda_2$, and $\lambda_3$ from interval $[0.05, 10]$. For $\theta$, one can select from {0.2, 0.3, 0.5, 1, 3, 5}.
- For other parameters, you can keep the default values.

### Citation
If you find our repo helpful, please consider leaving a star or citing our paper :)
```
@ARTICLE{RWLTA,
  author={Pu, Xinyu and Che, Hangjun and Pan, Baicheng and Leung, Man-Fai and Wen, Shiping},
  journal={IEEE Transactions on Computational Social Systems}, 
  title={Robust Weighted Low-Rank Tensor Approximation for Multiview Clustering With Mixed Noise}, 
  year={2023},
  volume={},
  number={},
  pages={1-18},
  doi={10.1109/TCSS.2023.3331366}
}
```

## ATTENTION
This package is free for academic usage. 

For other purposes, please contact Hangjun Che (hjche123@swu.edu.cn)

This package was developed by Xinyu Pu.

For any problem concerning the code, please feel free to contact Xinyu Pu (pushyu404@163.com)

## Contact
[Hangjun Che, SWU](mailto:hjche123@swu.edu.cn)

[Xinyu Pu, SWU](mailto:xndsb330@email.swu.edu.cn)

---
