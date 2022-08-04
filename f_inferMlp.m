
function Ipred = f_inferMlp(net,XTst,pram)

  NyJ   = pram.NyJ;
  NxJ   = pram.NxJ;
  n     = pram.n;

  Ypred = activations(net,XTst,'fc_out');
  Ipred = permute(Ypred,[4,3,1,2]);
  Ipred = reshape(Ipred,[NyJ NxJ n^2]);
  
  fun   = @(block_struct) reshape(block_struct.data,n,n);
  Ipred = blockproc(Ipred,[1 1],fun);

end