function D = calc_sift_color(image_path, color)
    if strcmp(color, 'RGB')
        im = im2single(imread(image_path));
    else
        im = im2single(color_spaces(image_path,color,0));
    end
   [Fr,Dr] = vl_sift(im(:,:,1));
   [Fg,Dg] = vl_sift(im(:,:,2));
   [Fb,Db] = vl_sift(im(:,:,3));
   %Frgb = [Fr,Fg,Fb];
   D = [Dr,Dg,Db];
end