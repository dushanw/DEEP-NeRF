

function [H,I,J,Jwf,Iwf] = f_preproc(H0,I0,J0,Jwf,Iwf,pram)

  rsf = pram.rsf;
  mxJ = max(Jwf(:));
  mxI = max(I0(:));
  mxH = max(H0(:));

  I   = imresize(I0,rsf);
  I   = I./mxI;
  Iwf = Iwf./mxI;

  H   = imresize(H0,rsf);
  H   = H./mxH;
  H   = 2*H - 1;

  J   = 2*J0 - Jwf;
  J   = J./mxJ;
  Jwf = Jwf./mxJ;
  
end