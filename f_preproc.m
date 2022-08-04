

function [H,I,J,Jwf,Iwf,pram] = f_preproc(H0,I0,J0,Jwf,Iwf,pram)

  rsf = pram.rsf;
  mxJ = max(Jwf(:));
  mxI = max(I0(:));
  mxH = max(H0(:));

  I   = imresize(I0,rsf);
  Iwf = imresize(Iwf,rsf);
  I   = I./mxI;
  Iwf = Iwf./mxI;

  H   = imresize(H0,rsf);
  H   = H ./ mxH;
  H   = H -  min(H(:));
  %H   = 2*H - 1;
  H   = H - mean(H,3);

  J   = imresize(J0 ,rsf);
  Jwf = imresize(Jwf,rsf);
% J   = 2*J0 - Jwf;
  J   = J - Jwf;
  J   = J./mxJ;
  Jwf = Jwf./mxJ;

  pram.NyI  = size(H,1);
  pram.NxI  = size(H,2);
  pram.NyJ  = pram.NyI/pram.n; 
  pram.NxJ  = pram.NxI/pram.n;  
  
end