classdef codedApertureLayer < nnet.layer.Layer        
  
    properties
        Nt        
        A_exPSF
        A_emPSF
    end

    properties (Learnable)

    end
    
    methods
      function layer = codedApertureLayer(numInputs,Nt,n,name)
            % layer = codedApertureLayer(numInputs,name) creates a
            % cpded aperture layer and specifies the number of inputs
            % and the layer name.

            % Set number of inputs.
            layer.NumInputs = numInputs;
            layer.Nt        = Nt;
            layer.A_exPSF   = reshape(diag(ones(1,n^2)),1,n^2,n^2);
            layer.A_emPSF   = reshape(diag(ones(1,n^2)),1,n^2,n^2);
            % Set layer name.
            layer.Name = name;
        end
        
        function Z = predict(layer, varargin)
            % Z = predict(layer, X1, ..., Xn) forwards the input data X1,
            % ..., Xn through the layer and outputs the result Z.
            
            X = varargin;
            
            % Initialize output
%             X1 = X{1};
%             sz = size(X1);            
%             Z = zeros(sz,'like',X1);
            X1 = X{1};            
            H  = X{2}(1:layer.Nt,1,:,:);
            H1 = permute(sum(layer.A_exPSF.*H,3),[1,3,2,4]);
            Z1 = X1.*H1;
            Z2 = sum(layer.A_emPSF.*Z1,3);
            Z  = sum(Z2,2);
            %Z  = sum(X1.*H1,3);
        end
    end
end