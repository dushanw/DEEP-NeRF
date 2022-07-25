function g = get_g6(Nx0,Ny0,n,B,H)
  
  [x,y] = meshgrid(linspace(0,1,Nx0),linspace(0,1,Ny0));

  B     = reshape(B,1,1,size(B,1),size(B,2));
  Bv    = x.*B(:,:,:,1)+y.*B(:,:,:,1);

  posEm = cat(3,cos(2*pi*Bv),sin(2*pi*Bv));
    
  g     = cat(3,H,posEm);
  
end

