function g = get_g5(Nx0,Ny0,n,B,H)
  
  [x,y] = meshgrid(linspace(0,1,Nx0),linspace(0,1,Ny0));
  
  fun   = @(block_struct) reshape(block_struct.data,1,1,[]);
  xblk  = permute(blockproc(x,[n n],fun),[3,1,2]);
  yblk  = permute(blockproc(y,[n n],fun),[3,1,2]);

  for i=1:Ny0/n
    for j=1:Nx0/n
      v           = [xblk(:,i,j) yblk(:,i,j)]';
      Bv(:,:,i,j) = B*v;
    end
  end
  posEm = cat(5,cos(2*pi*Bv),sin(2*pi*Bv));
  posEm = permute(posEm,[1 5 2 3 4]);

  %% H
  Nt    = size(H,3);
  for i=1:Nt
    H1(i,1,:,:,:) = blockproc(H(:,:,i),[n n],fun);
    H1(i,2,:,:,:) = blockproc(H(:,:,i),[n n],fun);
  end
  H1    = permute(H1,[1 2 5 3 4]);
  
  g     = cat(1,H1,posEm);
  g     = reshape(g,size(g,1),size(g,2),size(g,3),size(g,4)*size(g,5));

end

