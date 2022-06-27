
function [XTr,YTr,XTst,YTst] = f_getTrData(H,J,pram)
  
  NyJ   = pram.NyJ;
  NxJ   = pram.NxJ;
  NyI   = pram.NxI;  
  NxI   = pram.NxI;
  Nt    = pram.Nt;
  n     = pram.n;
  Nmap  = pram.Nmap;
  Bscal = pram.Bscal;
  fracTr= pram.fracTr;

  J     = permute(J,[3 1 2]);
  J     = reshape(J,Nt,1,1,NxJ*NyJ);

  B     = normrnd(zeros(Nmap,2),1)*Bscal;
  g     = ff_get_g5(NxI,NyI,n,B,H);
  
  ind_tr= rand([1,size(g,4)]) <= fracTr;
  XTr   = g(:,:,:,ind_tr);
  YTr   = J(:,:,:,ind_tr);
  
  XTst  = g;
  YTst  = J;

end