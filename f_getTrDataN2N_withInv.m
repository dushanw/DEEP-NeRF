
function [XTr,YTr,XTst,YTst] = f_getTrDataN2N_withInv(J,H,pram)
  
switch pram.rec_method
  case 'withH_deep2deep'        
    Mt     = pram.n2n_Mt;
    inds   = nchoosek(1:pram.Nt,Mt);
    if size(inds,1)>pram.NXTr_max
      temp = randperm(size(inds,1));
      inds = inds(temp(1:pram.NXTr_max),:);
    end
  
    t               = 1;  
    for i=1:size(inds,1)        
        %XTr(:,:,inds(i,:),t) = J(:,:,inds(i,:));
        XTr(:,:,:,t)          = J;
        YTr(:,:,:,t)          = f_dirInv_YeqAX(J(:,:,inds(i,:)),...
                                               H(:,:,inds(i,:)),...
                                               pram);
        t             = t+1 
    end
  case 'withH_yhatAll2deep'
    Mt     = pram.n2n_Mt;  
    inds   = nchoosek(1:pram.Nt,Mt);
    if size(inds,1)>pram.NXTr_max
      temp = randperm(size(inds,1));
      inds = inds(temp(1:pram.NXTr_max),:);
    end
  
    t               = 1;  
    for i=1:size(inds,1)        
        %XTr(:,:,inds(i,:),t) = J(:,:,inds(i,:));
        XTr(:,:,:,t)          = J;
        YTr(:,:,:,t)          = f_dirInv_YeqAX(J(:,:,inds(i,:)),...
                                               H(:,:,inds(i,:)),...
                                               pram);
        t             = t+1 
    end
  case 'withH_yhatMtDrop2deep'
    Mt     = pram.n2n_Mt;
    inds   = nchoosek(1:pram.Nt,Mt);
    if size(inds,1)>pram.NXTr_max
      temp = randperm(size(inds,1));
      inds = inds(temp(1:pram.NXTr_max),:);
    end
  
    t      = 1;  
    for i=1:size(inds,1)        
        XTr(:,:,inds(i,:),t) = J(:,:,inds(i,:));        
        YTr(:,:,:,t)         = f_dirInv_YeqAX(J(:,:,inds(i,:)),...
                                              H(:,:,inds(i,:)),...
                                              pram);
        t  = t+1 
    end
  case 'withH_yhatMt2deep'
    Mt     = pram.n2n_Mt;
    inds   = nchoosek(1:pram.Nt,Mt);
    if size(inds,1)>pram.NXTr_max
      temp = randperm(size(inds,1));
      inds = inds(temp(1:pram.NXTr_max),:);
    end
  
    t      = 1;  
    for i=1:size(inds,1)        
        XTr(:,:,:,t) = J(:,:,inds(i,:));        
        YTr(:,:,:,t)         = f_dirInv_YeqAX(J(:,:,inds(i,:)),...
                                              H(:,:,inds(i,:)),...
                                              pram);
        t  = t+1 
    end
end  
  rand_inds       = randperm(size(XTr,4));
  Ntest           = round(length(rand_inds)/100)+4;
  XTst            = XTr(:,:,:,rand_inds(1:Ntest));
  YTst            = YTr(:,:,:,rand_inds(1:Ntest));
  XTr             = XTr(:,:,:,rand_inds(Ntest+1:end));
  YTr             = YTr(:,:,:,rand_inds(Ntest+1:end));
end