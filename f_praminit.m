

function pram = f_praminit()

    % data parameter
    pram.datasetId  = 'data-20220730';            % look at all cases in f_readData(pram)
    pram.rsf        = 1/8;                        % down samples the system (H,I,J) by this factor
    pram.NyI        = 16; 
    pram.NxI        = 16; 
    pram.n          = 1;
    pram.NyJ        = pram.NyI/pram.n; 
    pram.NxJ        = pram.NxI/pram.n;  
    pram.Nt         = 16;
    
    % fwd-model parameters for simulated data
    pram.maxI       = 1e2;                        % photons per petterned-image per pixel on the sample 
    pram.maxJ       = pram.maxI*pram.n^2;         % photons per peterned-image per pixel on the detector
    
    % MLP embedding parameters 
    pram.Nmap       = 512;
    pram.Bscal      = 1;
    
    % MLP training parameter <uncomment when running NeRF>
%     pram.fracTr             = 1;                  % ratio of training data used for validation
%     pram.maxEpochs          = 1000;
%     pram.miniBatchSize      = 128;
%     pram.initLearningRate   = 1;
%     pram.learningRateFactor = .1;
%     pram.dropPeriod         = round(pram.maxEpochs/4);
%     pram.l2reg              = 0.0001;
%     pram.excEnv             = 'cpu';              % {'gpu','multi-gpu','cpu'}

    % N2N-FCN training parameter <uncomment when running N2N>
    pram.fracTr             = 1;                  % ratio of training data used for validation
    pram.maxEpochs          = 100;
    pram.miniBatchSize      = 32;
    pram.initLearningRate   = 1;
    pram.learningRateFactor = .1;
    pram.dropPeriod         = round(pram.maxEpochs/4);
    pram.l2reg              = 0.0001;
    pram.excEnv             = 'cpu';              % {'gpu','multi-gpu','cpu'}

end