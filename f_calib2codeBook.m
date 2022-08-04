

function Hc = f_calib2codeBook(H,codeBook)
    
  H   = double(H);
  mxH = max(H(:));
  H   = H ./ mxH;
  H   = H -  min(H(:));  
  H   = H - mean(H,3);

  codeBook  = double(codeBook);
  codeBook  = 2*(codeBook - 0.5);

  Ny = size(H,1);
  Nx = size(H,2);
  Nt = size(H,3);
  H1 = reshape(H,[Ny*Nx Nt]);
  
  H1xC = H1 * codeBook'; 
  [temp codeInds] = max(H1xC,[],2);

  Hc = zeros(size(H1));
  for i=1:Nt
    inds = find(codeInds==i);
    Hc(inds,:) = repmat(codeBook(i,:),length(inds),1); 
  end
  Hc = reshape(Hc,[Ny Nx Nt]);

%   codeInds = reshape(codeInds,[Ny Nx]);
%   codeInds2= codeInds;
%   for i=1:16
%     inds = find(codeInds==i+16);
%     codeInds2(inds) = 16-i+1; 
%   end
  
end











