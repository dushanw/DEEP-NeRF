classdef codedApertureLayer < nnet.layer.Layer        
  
    properties
        Nt
    end

    properties (Learnable)
    
    end
    
    methods
        function layer = codedApertureLayer(numInputs,Nt,name) 
            % layer = codedApertureLayer(numInputs,name) creates a
            % cpded aperture layer and specifies the number of inputs
            % and the layer name.

            % Set number of inputs.
            layer.NumInputs = numInputs;
            layer.Nt        = Nt;
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
            X2 = X{2}(1:layer.Nt,1,:,:);
            Z  = sum(X1.*X2,3);
        end
    end
end