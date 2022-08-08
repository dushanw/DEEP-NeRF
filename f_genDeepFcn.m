function lgraph = f_genDeepFcn(pram)
     
  fcn_input_size = pram.n2n_input_size;
  net0_dncnn = denoisingNetwork('dncnn');
  lgraph = layerGraph(net0_dncnn.Layers);
    
  lgraph = replaceLayer(lgraph,'InputLayer',imageInputLayer(fcn_input_size,'Name','InputLayer','Normalization','none'));        
  lgraph = replaceLayer(lgraph,'Conv1',convolution2dLayer([3 3],64,'Name','Conv1','NumChannels',fcn_input_size(3),'Padding',[1 1 1 1],'stride',[1  1]));        
    
  lgraph = removeLayers(lgraph,{lgraph.Layers(13:55).Name});  
  lgraph = connectLayers(lgraph,'ReLU4','BNorm19');

end