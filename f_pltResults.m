
function f_pltResults(Igt,Iwf,Jwf,Ipred,pram)
  
  NyI       = pram.NyI;
  NxI       = pram.NxI;
  n         = pram.n;
  Nt        = pram.Nt;

  Jwf4plt   = imresize(Jwf,[NyI NxI],"box"); 
  Ipredplt  = Ipred*n^2;

  imagesc([Jwf4plt Ipredplt; Igt Iwf],[0 1]);axis image
  title("J-wf(top-left), I-pred(top-right),I-gt(bottom-left), I-wf(bottom-right)")

end