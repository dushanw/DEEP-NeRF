
function f_pltResults_withInv(Iwf,J0,Xhat_inv,Ytr1,YTr_avg,Ypred,pram)
  
  Iwf     (Iwf      <0) = 0;
  J0      (J0       <0) = 0;
  Xhat_inv(Xhat_inv <0) = 0;
  Ytr1    (Ytr1     <0) = 0;
  YTr_avg (YTr_avg  <0) = 0;
  Ypred   (Ypred    <0) = 0;
  
  imagesc([rescale(Iwf)   rescale(J0(:,:,1)) rescale(Xhat_inv); ...
           rescale(Ytr1)  rescale(YTr_avg)   rescale(Ypred)     ...
           ]);axis image
  title('(1)Xhat_t (2)Xhat_Inv (3)Xhat-n2n-Nt (4)Xhat-n2n-Mt-1 (5)mean(Xhat-n2n-Mt-all) (6)I0')
  set(gca,'fontsize',8)
  mkdir(['./__results/' date '_n2nwithInv/'])
  saveas(gcf,['./__results/' date '_n2nwithInv/'...
               pram.datasetId '_Nt-' ...
               num2str(pram.Nt) '_Mt-' ...
               num2str(pram.n2n_Mt) ...
               datetime '.fig'])

end