function Displaysuperpixels(label,img,name)
  % part of boundaries are ploted
  boundaries = abs(imfilter(label, [0 -1 1],'replicate'))>0 | abs(imfilter(label, [0 -1 1]', 'replicate'))>0;
  edges_thinned = bwmorph(boundaries, 'thin', Inf);
  itm1 = img(:,:,1);
  itm2 = img(:,:,2);
  itm3 = img(:,:,3);
  itm1( edges_thinned) = 255;
  itm2( edges_thinned) = 0;
  itm3( edges_thinned) = 0;
  itm(:,:,1) = itm1;
  itm(:,:,2) = itm2;
  itm(:,:,3) = itm3;
  
  imwrite(itm,name)