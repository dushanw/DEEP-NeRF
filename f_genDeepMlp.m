function lgraph = f_genDeepMlp(pram,mlp_input_size)
   
  Nmap            = pram.Nmap; 
  n               = pram.n;
  Nt              = pram.Nt;

  layers = [ ...
      imageInputLayer(mlp_input_size(1:3),'Normalization','none',"Name","input")
      fullyConnectedLayer(Nmap)
      reluLayer
      fullyConnectedLayer(Nmap)
      reluLayer
      fullyConnectedLayer(Nmap)
      reluLayer
      fullyConnectedLayer(Nmap)
      reluLayer
      %fullyConnectedLayer((2*n)^2,"Name","fc_out")
      %codedApertureLayer_v2(2,Nt,n,'coded_aperture')
      fullyConnectedLayer(n^2,"Name","fc_out")
      codedApertureLayer(2,Nt,n,'coded_aperture');
      %aproxPoissonLayer('noise',avgI)
      regressionLayer
      %maeRegressionLayer('regression')
      ];  
  lgraph = layerGraph(layers);
  lgraph = connectLayers(lgraph,"input","coded_aperture/in2");
end