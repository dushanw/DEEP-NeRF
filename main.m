% 2022-06-22 by Dushan N. Wadduwage
% Using MLPs to encode micrsocpe images
% base paper: https://bmild.github.io/fourfeat/index.html

% Method:(x,y) -> g(x,y) -> MLP -> [I(x,y)]_block -> Fwd(I_block) -> J(xx,yy) 
% Data  :DEEP patterns (H0), DEEP images(J0), Wide-feild image (Jwf)

clc;close all;clear all
addpath('./_custom_layers/')

%% parameter initialization
pram = f_praminit();
pram.datasetId  = 'data-20220621-tissue';
 
%% read and pre-process data
[H0,I0,J0,Jwf,Iwf,pram] = f_readData(pram);                     % read DEEP data
[H ,I ,J ,Jwf,Iwf,pram] = f_preproc(H0,I0,J0,Jwf,Iwf,pram);     % pre-process H, and J
%H                      = f_calib2codeBook(H,pram.codeBook);    % the temporal-code-book-based H

%% traditional y=Ax reconstruction
Xhat = f_dirInv_YeqAX(J,H,pram);
imagesc([rescale(imresize(Jwf,pram.n)) rescale(Xhat) rescale(I0)]);axis image

%% no-H-information reconstruction for optical sectioning (only for n=1)
Xhat_t          = abs(J0 - mean(J0,3))*2;

clear XTr YTr 
t = 1;
Mt = pram.Nt-3;
fcn_input_size  = [size(Xhat_t,1) size(Xhat_t,2) Mt]
for i=1:pram.Nt
  inds = setdiff(1:pram.Nt,i);
  inds = nchoosek(inds,Mt);
  for j=1:size(inds,1)        
    XTr(:,:,:,t)    = Xhat_t(:,:,inds(j,:));
    YTr(:,:,:,t)    = Xhat_t(:,:,i);
    t = t+1
  end
end

%fcn_input_size  = [size(Xhat_t,1) size(Xhat_t,2) 1]
lgraph          = f_genDeepFcn(pram,fcn_input_size);
% 
% for i=1:pram.Nt
%   Xhat_t_avg(:,:,i) = mean(Xhat_t(:,:,setdiff(1:pram.Nt,i)),3);   
% end
% 
% for i=1:pram.Nt
%   for j=setdiff(1:pram.Nt,i)
%     XTr(:,:,1,t)    = Xhat_t_avg(:,:,i);
%     YTr(:,:,1,t)    = Xhat_t_avg(:,:,j);    
%     t=t+1;
%   end
% end

rand_inds       = randperm(size(XTr,4));
XTst            = XTr(:,:,:,rand_inds(1:32));
YTst            = YTr(:,:,:,rand_inds(1:32));
XTr             = XTr(:,:,:,rand_inds(32:end));
YTr             = YTr(:,:,:,rand_inds(32:end));

pram.initLearningRate   = 1;
pram.maxEpochs      = 100;
pram.miniBatchSize  = 32;
pram.excEnv         = 'gpu';
pram.dropPeriod     = round(pram.maxEpochs/4);
options             = f_set_training_options(pram,XTst,YTst);
[net, tr_info]      = trainNetwork(XTr,YTr,lgraph,options);
Ypred               = activations(net,XTst,'Conv20');

Ypred               = activations(net,cat(4,XTst,XTr),'Conv20');
%imagesc([rescale(XTst(:,:,1)) rescale(Ypred(:,:,1,1)); rescale(mean(Ypred,4)) rescale(I0)]);axis image
imagesc([rescale(Xhat_t(:,:,1)) rescale(mean(Xhat_t,3)) rescale(Xhat);...
         rescale(Ypred(:,:,1,1)) rescale(mean(Ypred,4)) rescale(I0)]);axis image
title('(1)Xhat_t (2)mean(Xhat_t) (3)Xhat-inv (4)Ypred1 (5)mean(YpredAll) (6)I0')
set(gca,'fontsize',8)
saveas(gcf,['./__results/2022-08-08_noise2noise/' pram.datasetId '_Nt-' num2str(pram.Nt) '_Mt-' num2str(Mt) '.fig'])

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





