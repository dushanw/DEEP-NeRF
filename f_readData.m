
function [H0,I0,J0,Jwf,Iwf,pram] = f_readData(pram)

  switch pram.datasetId
    case 'sim-cell'      
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
    case 'data-20220608'      
      load ./_data/data-20220608.mat
      I0        = imresize(mean(data.Ir1,3),1/2,"box");
      H0        = imresize(data.Hr1(:,:,1:pram.Nt),1/2,"box");
      %J0       = imresize(data.Ir1(:,:,1:pram.Nt),1/4,"box");
      %J0       = imresize(J0,1/pram.n,"box")*pram.n^2;% bin
      %Jwf      = imresize(I0,1/pram.n,"box")*pram.n^2;% bin
      J0        = imresize(data.Ir1_8(:,:,1:pram.Nt),1,"box");
      Jwf       = mean(J0,3);% bin
      Iwf       = I0;
      pram.NyI  = size(I0,1);
      pram.NxI  = size(I0,2);
      pram.NyJ  = pram.NyI/pram.n; 
      pram.NxJ  = pram.NxI/pram.n;  
      pram.rsf = 1;
  end

end



