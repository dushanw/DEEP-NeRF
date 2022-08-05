
function [H0,I0,J0,Jwf,Iwf,pram] = f_readData(pram)

  switch pram.datasetId       
    case 'sim-cell-wf'  
      %% 
      I0        = rescale(imread("_data/cell.tif"));
      I0        = imresize(I0,0.25);
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.rsf  = 1;
      
      % fwd model      
      H0        = ones([pram.NyI pram.NxI pram.Nt]);
      J0        = imresize(I0.*H0,1/pram.n,"box")*pram.n^2;% modualtion and bin
      Jwf       = imresize(I0    ,1/pram.n,"box")*pram.n^2;% wide-feild and bin
      J0        = poissrnd(J0 *pram.maxJ)/pram.maxJ;% add noise
      Jwf       = poissrnd(Jwf*pram.maxJ)/pram.maxJ;% add noise
      % equivelent wf image with the expsure time of all patterns
      Iwf       = poissrnd(I0*pram.maxI*pram.Nt)/(pram.maxI*pram.Nt);% add noise
    case 'sim-cell'  
      %% 
      I0        = rescale(imread("_data/cell.tif"));
      I0        = imresize(I0,0.25);
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.rsf  =1;

      % fwd model      
      H0        = rand([pram.NyI pram.NxI pram.Nt])>0.5;
      J0        = imresize(I0.*H0,1/pram.n,"box")*pram.n^2;% modualtion and bin
      Jwf       = imresize(I0    ,1/pram.n,"box")*pram.n^2;% wide-feild and bin
      J0        = poissrnd(J0 *pram.maxJ)/pram.maxJ;% add noise
      Jwf       = poissrnd(Jwf*pram.maxJ)/pram.maxJ;% add noise
      % equivelent wf image with the expsure time of all patterns
      Iwf       = poissrnd(I0*pram.maxI*pram.Nt)/(pram.maxI*pram.Nt);% add noise
    case 'sim-cell-with-bg'  
      %% 
      I0        = rescale(imread("_data/cell.tif"));
      I0        = imresize(I0,0.25);
      I0_bg     = imgaussfilt(I0,10) + 0.1;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.rsf  =1;

      % fwd model      
      H0        = rand([pram.NyI pram.NxI pram.Nt/2])>0.5;
      H0        = cat(3,H0,~H0);
      J0        = imresize(I0.*H0+I0_bg,1/pram.n,"box")*pram.n^2;% modualtion and bin
      Jwf       = imresize(I0+I0_bg    ,1/pram.n,"box")*pram.n^2;% wide-feild and bin
      J0        = poissrnd(J0 *pram.maxJ)/pram.maxJ;% add noise
      Jwf       = poissrnd(Jwf*pram.maxJ)/pram.maxJ;% add noise
      % equivelent wf image with the expsure time of all patterns
      Iwf       = poissrnd(I0*pram.maxI*pram.Nt)/(pram.maxI*pram.Nt);% add noise
    case 'data-20220608'      
      %%
      load ./_data/data-20220608.mat
      I0        = imresize(mean(data.Ir1,3),1/8,"box");
      H0        = imresize(data.Hr1(:,:,1:pram.Nt),1/8,"box");
      %J0       = imresize(data.Ir1(:,:,1:pram.Nt),1/4,"box");
      %J0       = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %%Jwf      = imresize(I0,1/pram.n,"box")*pram.n^2;% bin
      J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf  = 1;
    case 'data-20220621-reflection'
      %%
      load ./_data/data-20220621-reflection.mat
      I0        = imresize(mean(Data.Irt,3),1/4,"box");
      H0        = imresize(Data.H(:,:,1:pram.Nt),1/4,"box");

      %J0       = imresize(Data.Irt(:,:,1:pram.Nt),1/4,"box");
      %J0       = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %%Jwf     = imresize(I0,1/pram.n,"box")*pram.n^2;% bin
      
      J0       = imresize(Data.Irt_8(:,:,1:pram.Nt),1/2,"box");
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf = 1; 
    case 'data-20220621-cells'
      %%
      load ./_data/data-20220621-cells.mat
      I0        = imresize(mean(data.Irt,3),1/4,"box");
      H0        = imresize(data.H(:,:,1:pram.Nt),1/4,"box");      
      % 512x512
      J0        = imresize(data.Irt(:,:,1:pram.Nt),1/4,"box");
      J0        = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %%Jwf      = imresize(I0,1/pram.n,"box")*pram.n^2;% bin      
      % 128x128
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      % 64x64
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf  = 1;
      
    case 'data-20220707-cells-and-r6g'
      %%
      if pram.Nt>32
        pram.Nt   = 32;
      end
      load ./_data/data-20220707-cells-and-r6g.mat
      I0        = imresize(double(mean(data.Irt_rsf4,3)),1/1,"box");
      H0        = imresize(double(data.Hrt_rsf4(:,:,1:pram.Nt)),1/1,"box");      
      % 400x400
      J0        = imresize(double(data.Irt_rsf4(:,:,1:pram.Nt)),1/1,"box");
      J0        = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %%Jwf      = imresize(I0,1/pram.n,"box")*pram.n^2;% bin      
      % 128x128
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      % 64x64
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf  = 1;
      pram.codeBook = data.codeBook;
    case 'data-20220722'
      %%
      if pram.Nt>32
        pram.Nt   = 32;
      end
      load ./_data/data-20220722_noReg.mat
      data.I_rsf8 = data.I_rsf8(1:726,401:726+400,:);
      data.H_rsf8 = data.H_rsf8(1:726,401:726+400,:);

      NyI       = 128;
      NxI       = NyI;
      I0        = imresize(double(mean(data.I_rsf8,3)),[NyI NxI]);
      H0        = imresize(double(data.H_rsf8(:,:,1:pram.Nt)),[NyI NxI]);      
      J0        = imresize(double(data.I_rsf8(:,:,1:pram.Nt)),[NyI NxI]);

%       I0        = imresize(double(mean(data.I_rsf8,3)),[NyI NxI],"box");
%       H0        = imresize(double(data.H_rsf8(:,:,1:pram.Nt)),[NyI NxI],"box");      
%       J0        = imresize(double(data.I_rsf8(:,:,1:pram.Nt)),[NyI NxI],"box");
      J0        = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %%Jwf      = imresize(I0,1/pram.n,"box")*pram.n^2;% bin      
      % 128x128
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      % 64x64
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf  = 1;
      pram.codeBook = data.codeBook;
             
    case 'data-20220730'
      %%
      if pram.Nt>32
        pram.Nt   = 32;
      end
      load ./_data/data-20220730.mat
      data.I_rsf8 = data.I_rsf8(1:640,401:640+400,:);
      data.H_rsf8 = data.H_rsf8(1:640,401:640+400,:);

      NyI       = 128;
      NxI       = NyI;
      I0        = imresize(double(mean(data.I_rsf8,3)),[NyI NxI]);
      H0        = imresize(double(data.H_rsf8(:,:,1:pram.Nt)),[NyI NxI]);      
      J0        = imresize(double(data.I_rsf8(:,:,1:pram.Nt)),[NyI NxI]);

%       I0        = imresize(double(mean(data.I_rsf8,3)),[NyI NxI],"box");
%       H0        = imresize(double(data.H_rsf8(:,:,1:pram.Nt)),[NyI NxI],"box");      
%       J0        = imresize(double(data.I_rsf8(:,:,1:pram.Nt)),[NyI NxI],"box");
      J0        = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %%Jwf      = imresize(I0,1/pram.n,"box")*pram.n^2;% bin      
      % 128x128
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      % 64x64
      %J0       = imresize(data.Ir1_8(:,:,1:pram.Nt),1/4,"box");
      
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf  = 1;
  end

end



