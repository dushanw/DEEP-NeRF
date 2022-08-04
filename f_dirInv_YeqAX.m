
function Xhat = f_dirInv_YeqAX(J,H,pram)

  n   = pram.n;
  Ny  = size(J,1);
  Nx  = size(J,2);
  Ny0 = size(H,1);
  Nx0 = size(H,2);
  Nt  = size(H,3);

  % make A
  i_vec = [1:Ny*Nx*Nt]';  
  i_vec = reshape(i_vec,[Ny Nx Nt]);
  i_vec = imresize(i_vec,n,"box");
  i_vec = i_vec(:);
  
  j_vec = repmat(1:Ny0*Nx0,[1 Nt])';
  s_vec = H(:);
  A = sparse(i_vec,j_vec,s_vec,Ny*Nx*Nt,Ny0*Nx0);

  Xhat = A\J(:);                 % solve original system  
  %Xhat = (A'*A)\(A'*J(:));       % solve reduced systems by At
  Xhat = reshape(Xhat,Ny0,Nx0);

  %Xhat(Xhat<0)=0;
  imagesc(Xhat);axis image
end