% 2022-06-22 by Dushan N. Wadduwage
% Using MLPs to encode micrsocpe images
% base paper: https://bmild.github.io/fourfeat/index.html

% Method:(x,y) -> g(x,y) -> MLP -> [I(x,y)]_block -> Fwd(I_block) -> J(xx,yy) 
% Data  :DEEP patterns (H0), DEEP images(J0), Wide-feild image (Jwf)

clc;close all;clear all
addpath('./_custom_layers/')

%% parameter initialization
pram = f_praminit();

%% read and pre-process data
[H0,I0,J0,Jwf,Iwf,pram] = f_readData(pram);                     % read DEEP data
[H ,I ,J ,Jwf,Iwf,pram] = f_preproc(H0,I0,J0,Jwf,Iwf,pram);     % pre-process H, and J
%H                      = f_calib2codeBook(H,pram.codeBook);    % the temporal-code-book-based H

%% traditional y=Ax reconstruction
Xhat = f_dirInv_YeqAX(J,H,pram);
imagesc([rescale(imresize(Jwf,pram.n)) rescale(Xhat) rescale(I0)]);axis image

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





