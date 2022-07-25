
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

  B     = normrnd(zeros(Nmap,2),1)*Bscal;

  J     = permute(J,[3 1 2]);
  J     = reshape(J,Nt,1,1,NxJ*NyJ);
  g     = ff_get_g5(NxI,NyI,n,B,H);
  
  ind_tr= rand([1,size(g,4)]) <= fracTr;
  XTr   = g(:,:,:,ind_tr);
  YTr   = J(:,:,:,ind_tr);
  
  XTst  = g;
  YTst  = J;
  

%   g     = ff_get_g6(NxI,NyI,n,B,H);
%   t     = 1;
%   J     = imresize(J,[NyI NxI]);
%   for i=1:n/2:NyI-2*n
%     for j=1:n/2:NxI-2*n
%       XTst(:,:,:,t) = g(i:i+2*n-1,j:j+2*n-1,:);
%       %YTst(1,1,:,t) = J(i+n/2,j+n/2,:);
%       YTst(:,:,:,t) = J(i+n/2:i+3*n/2-1,j+n/2:j+3*n/2-1,:);
%       t = t+1;
%     end
%   end
%   ind_tr= rand([1,size(YTst,4)]) <= fracTr;
%   XTr   = XTst(:,:,:,ind_tr);
%   YTr   = YTst(:,:,:,ind_tr);
  
end