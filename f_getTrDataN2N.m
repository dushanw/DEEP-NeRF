
function [XTr,YTr,XTst,YTst] = f_getTrDataN2N(J0,pram)

  Xhat_t          = abs(J0 - mean(J0,3))*2;
  Mt              = pram.n2n_Mt;
  %fcn_input_size = [size(Xhat_t,1) size(Xhat_t,2) Mt];
  fcn_input_size  = pram.n2n_input_size;
  
  t               = 1;
  for i=1:pram.Nt
    inds = setdiff(1:pram.Nt,i);
    inds = nchoosek(inds,Mt);
    for j=1:size(inds,1)        
      XTr(:,:,:,t)  = Xhat_t(:,:,inds(j,:));
      YTr(:,:,:,t)  = Xhat_t(:,:,i);
      t             = t+1;
    end
  end
  
  %fcn_input_size  = [size(Xhat_t,1) size(Xhat_t,2) 1]  
  % 
  % for i=1:pram.Nt
  %   Xhat_t_avg(:,:,i) = mean(Xhat_t(:,:,setdiff(1:pram.Nt,i)),3);   
  % end
  % 
  % for i=1:pram.Nt
  %   for j=setdiff(1:pram.Nt,i)
  %     XTr(:,:,1,t)    = Xhat_t_avg(:,:,i);
  %     YTr(:,:,1,t)    = Xhat_t_avg(:,:,j);    
  %     t=t+1;
  %   end
  % end
  
  rand_inds       = randperm(size(XTr,4));
  Ntest           = round(length(rand_inds)/100)+4;
  XTst            = XTr(:,:,:,rand_inds(1:Ntest));
  YTst            = YTr(:,:,:,rand_inds(1:Ntest));
  XTr             = XTr(:,:,:,rand_inds(Ntest+1:end));
  YTr             = YTr(:,:,:,rand_inds(Ntest+1:end));  
end