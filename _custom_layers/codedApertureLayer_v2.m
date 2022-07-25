classdef codedApertureLayer_v2 < nnet.layer.Layer        
  
    properties
        Nt
        n
        psf
    end

    properties (Learnable)
        
    end
    
    methods
      function layer = codedApertureLayer_v2(numInputs,Nt,n,name) 
            % layer = codedApertureLayer(numInputs,name) creates a
            % cpded aperture layer and specifies the number of inputs
            % and the layer name.

            % Set number of inputs.
            layer.NumInputs = numInputs;
            layer.Nt        = Nt;
            layer.n         = n;
            % Set layer name.
            layer.Name      = name;
            % estimate psf 
            layer.psf       = fspecial('gaussian',n+1,n/3);
        end
        
        function Z = predict(layer, varargin)
            % Z = predict(layer, X1, ..., Xn) forwards the input data X1,
            % ..., Xn through the layer and outputs the result Z.
            
            X = varargin;
            
            % Initialize output
%             X1 = X{1};
%             sz = size(X1);            
%             Z = zeros(sz,'like',X1);
            X1 = reshape(X{1},2*layer.n,2*layer.n,1,[]);
            H  = X{2}(:,:,1:layer.Nt,:);            
            %Z  = dlconv(X1.*H,layer.psf,0,DataFormat="SSCB");
            %Z = dlconv(X1.*H,layer.psf,0,DataFormat="SSTB");
            Z1 = X1.*H;
            Z = Z1(layer.n/2+1:3*layer.n/2,layer.n/2+1:3*layer.n/2,:,:);
        end
    end
end