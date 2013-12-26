function D = calc_sift_color(image_path, color)
% Function to calculate a given color space SIFT descriptor
% Arguments:
%     image_path
%     color: 'RGB', 'rgb', 'opponent', 'hsv'

    im_t = im2single(imread(image_path));
    if strcmp(color, 'RGB') || size(im_t,3) == 1
        im = im_t;
    else
        im = im2single(color_spaces(image_path,color,0));
    end
    if size(im,3) == 3
        [Fr,Dr] = vl_sift(im(:,:,1));
        [Fg,Dg] = vl_sift(im(:,:,2));
        [Fb,Db] = vl_sift(im(:,:,3));
        %Frgb = [Fr,Fg,Fb];
        D = [Dr,Dg,Db];
    else
        [F,D] = vl_sift(im);
    end
end