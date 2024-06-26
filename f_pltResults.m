
function f_pltResults(Igt,Iwf,Jwf,Ipred,pram)
  
  NyI       = pram.NyI;
  NxI       = pram.NxI;
  n         = pram.n;
  Nt        = pram.Nt;

  Jwf4plt   = imresize(Jwf,[NyI NxI],"box"); 
  Ipredplt  = Ipred;
  Ipredplt(Ipredplt<0)=0;

  imagesc([rescale(Jwf4plt)...
           rescale(Ipredplt);...
           rescale(Igt)...
           rescale(Iwf)],[0 1]);axis image
  title("J-wf(top-left), I-pred(top-right),I-gt(bottom-left), I-wf(bottom-right)")

end