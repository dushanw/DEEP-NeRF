% 2022-06-22 by Dushan N. Wadduwage
% Using MLPs to encode micrsocpe images
% base paper: https://bmild.github.io/fourfeat/index.html

% Method:(x,y) -> g(x,y) -> MLP -> [I(x,y)]_block -> Fwd(I_block) -> J(xx,yy) 
% Data  :DEEP patterns (H0), DEEP images(J0), Wide-feild image (Jwf)

clc;close all;clear all
addpath('./_custom_layers/')

%% parameter initialization
% data parameter
pram.datasetId  = 'data-20220621-cells';      % {'sim-cell',
                                              %  'data-20220608',
                                              %  'data-20220621-reflection',
                                              %  'data-20220621-cells'}
pram.rsf        = 1/8;                        % down samples the system (H,I,J) by this factor
pram.NyI        = 128; 
pram.NxI        = 128; 
pram.n          = 4;
pram.NyJ        = pram.NyI/pram.n; 
pram.NxJ        = pram.NxI/pram.n;  
pram.Nt         = 32;

% fwd-model parameters for simulated data
pram.maxI       = 1e3;                        % photons per petterned-image per pixel on the sample 
pram.maxJ       = pram.maxI*pram.n^2;         % photons per petterned-image per pixel on the detector

% MLP embedding parameters 
pram.Nmap       = 512;
pram.Bscal      = .1;

% MLP training parameter
pram.fracTr             = 1;              % ratio of training data used for validation
pram.maxEpochs          = 1000;
pram.miniBatchSize      = 1024*8;
pram.initLearningRate   = 1;
pram.learningRateFactor = .1;
pram.dropPeriod         = round(pram.maxEpochs/4);
pram.l2reg              = 0.0001;
pram.excEnv             = 'gpu';          % {'gpu','multi-gpu','cpu'}

%% 
[H0,I0,J0,Jwf,Iwf,pram] = f_readData(pram);                     % read DEEP data
[H ,I ,J ,Jwf,Iwf,pram] = f_preproc(H0,I0,J0,Jwf,Iwf,pram);     % pre-process H, and J

[XTr,YTr,XTst,YTst]     = f_getTrData(H,J,pram);                % generate training data
lgraph                  = f_genDeepMlp(pram,size(XTr));         % MLP + DEEP-fwd model

options                 = f_set_training_options(pram,XTst,YTst); % train MLP
[net, tr_info]          = trainNetwork(XTr,YTr,lgraph,options); % "
Ipred                   = f_inferMlp(net,XTst,pram);            % infer MLP

f_pltResults(I,Iwf,Jwf,Ipred,pram);                       % visualize results
