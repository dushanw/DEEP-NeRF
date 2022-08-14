%% readme
% 2022-06-22 by Dushan N. Wadduwage
% Nerf - Using MLPs to encode micrsocpe images
% base paper: https://bmild.github.io/fourfeat/index.html
% Method:(x,y) -> g(x,y) -> MLP -> [I(x,y)]_block -> Fwd(I_block) -> J(xx,yy) 
% Data  :DEEP patterns (H0), DEEP images(J0), Wide-feild image (Jwf)
%
% N2N - Using noise-2-noise for DEEP reconsturction
% base paper: https://arxiv.org/abs/1803.04189 (Noise2Noise: Learning Image Restoration without Clean Data)
% Method: J(x,y,t=1:Mt) - mean(J(x,x,t),over_t) -> Ihat ;
%         loss(Ihat,J(x,y,Mt++) - mean(J(x,x,t),over_t)); 

%% clean workspace
clc;close all;clear all
addpath('./_custom_layers/')

%% parameter initialization
pram = f_praminit();
pram.NyI        = 64;
pram.NxI        = 64;
pram.Nt         = 32;
pram.datasetId  = 'two-photon-bv-20201224';
 
%% read and pre-process data
[H0,I0,J0,Jwf,Iwf,pram] = f_readData(pram);                     % read DEEP data
[H ,I ,J ,Jwf,Iwf,pram] = f_preproc(H0,I0,J0,Jwf,Iwf,pram);     % pre-process H, and J
%H                      = f_calib2codeBook(H,pram.codeBook);    % the temporal-code-book-based H

%% traditional y=Ax reconstruction
Xhat = f_dirInv_YeqAX(J,H,pram);
imagesc([rescale(imresize(Jwf,pram.n)) rescale(Xhat);...
         rescale(mean(abs(J-mean(J,3)),3))            rescale(I0)]);axis image

%% N2N: no-H-information reconstruction for optical sectioning (only for n=1)
pram.n2n_Mt           = pram.Nt - 3;
pram.n2n_input_size   = [pram.NyJ pram.NxJ pram.n2n_Mt];

%[XTr,YTr,XTst,YTst]  = f_getTrDataN2N(J0,pram);
[XTr,YTr,XTst,YTst]   = f_getTrDataN2N(J,pram);
lgraph                = f_genDeepFcn(pram);
options               = f_set_training_options(pram,XTst,YTst);
[net, tr_info]        = trainNetwork(XTr,YTr,lgraph,options);

Ypred                 = activations(net,cat(4,XTst,XTr),'Conv20');

imagesc([rescale(YTr(:,:,1,1)) rescale(mean(YTr,4)) rescale(Xhat);...
         rescale(Ypred(:,:,1,1)) rescale(mean(Ypred,4)) rescale(I0)]);axis image
title('(1)Xhat_t (2)mean(Xhat_t) (3)Xhat-inv (4)Ypred1 (5)mean(YpredAll) (6)I0')
set(gca,'fontsize',8)
saveas(gcf,['./__results/2022-08-08_noise2noise/' pram.datasetId '_Nt-' num2str(pram.Nt) '_Mt-' num2str(Mt) '.fig'])

%% N2N: with-H-information reconstruction (not implemented yet!!!)
%pram.n2n_Mt           = pram.Nt/2;
pram.n2n_Mt           = pram.Nt-4;
pram.n2n_input_size   = [pram.NyJ pram.NxJ pram.Nt];
pram.NXTr_max         = 1e5;
pram.excEnv           = 'gpu';
pram.maxEpochs        = 40;
pram.initLearningRate = 0.1;
pram.dropPeriod       = round(pram.maxEpochs/4);
pram.miniBatchSize    = 128;

[XTr,YTr,XTst,YTst]   = f_getTrDataN2N_withInv(J,H,pram);
lgraph                = f_genDeepFcn(pram);

YTst                  = Xhat;
XTst                  = XTst(:,:,:,1);
options               = f_set_training_options(pram,XTst,YTst);
[net, tr_info]        = trainNetwork(XTr,YTr,lgraph,options);

%Ypred                 = activations(net,cat(4,XTst,XTr),'Conv20');
Ypred                 = activations(net,XTst(:,:,:,1),'Conv20');
Ypred_all             = activations(net,J,'Conv20');
Ypred(Ypred<0)=0;
Ypred_all(Ypred_all<0)=0;

% Ypred                 = activations(net,XTst(:,:,:,1),'ReLU_last');
% Ypred_all             = activations(net,J,'ReLU_last');

imagesc([rescale(mean(YTr,4))     rescale(Xhat)          rescale(Ypred_all) ;...
         rescale(Ypred(:,:,1,1))  rescale(mean(Ypred,4)) rescale(I0)]       );axis image
title('(1)Xhat_t (2)Xhat_Inv (3)Xhat-n2n-Nt (4)Xhat-n2n-Mt-1 (5)mean(Xhat-n2n-Mt-all) (6)I0')
set(gca,'fontsize',8)
saveas(gcf,['./__results/2022-08-11_noise2noisewithInv/'...
             pram.datasetId '_Nt-' ...
             num2str(pram.Nt) '_Mt-' ...
             num2str(pram.n2n_Mt) 'AllInput_sf.fig'])

%% NeRF (MPL) reconstruction no-preproc
[XTr,YTr,XTst,YTst]     = f_getTrData(H0,J0,pram);              % generate no-preproc training data 
lgraph                  = f_genDeepMlp(pram,size(XTr));         % MLP + DEEP-fwd model

options                 = f_set_training_options(pram,XTst,YTst); % train MLP
[net, tr_info]          = trainNetwork(XTr,YTr,lgraph,options); % "
Ipred                   = f_inferMlp(net,XTst,pram);            % infer MLP

f_pltResults(I0,Iwf,Jwf,Ipred,pram);                             % visualize results

%% NeRF (MPL) reconstruction with preproc
[XTr,YTr,XTst,YTst]     = f_getTrData(H,J,pram);                % generate training data (with preprocessing)
lgraph                  = f_genDeepMlp(pram,size(XTr));         % MLP + DEEP-fwd model

options                 = f_set_training_options(pram,XTst,YTst); % train MLP
[net, tr_info]          = trainNetwork(XTr,YTr,lgraph,options); % "
Ipred                   = f_inferMlp(net,XTst,pram);            % infer MLP

f_pltResults(I,Iwf,Jwf,Ipred,pram);                             % visualize results





