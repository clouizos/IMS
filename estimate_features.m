function features = estimate_features(num_samples, type, voc_size, reg, vis)
close all;
%voc_size = 400;
% parse the vocabulary
if nargin == 4
    vis = 0;
end
if voc_size == 400
    voc_ = load('visual_vocabulary_1000_400.mat');
elseif voc_size == 800
    voc_ = load('visual_vocabulary_1000_800.mat');
elseif voc_size == 1600
    voc_ = load('visual_vocabulary_1000_1600.mat');
elseif voc_size == 2000
    voc_ = load('visual_vocabulary_1000_2000.mat');
elseif voc_size == 4000
    voc_ = load('visual_vocabulary_1000_4000.mat');
end
% voc has integers here, need to investigate
voc = voc_.voc';
if strcmp(type,'train')
    air_train = './data/airplanes_train/';
    car_train = './data/cars_train/';
    face_train = './data/faces_train/';
    motor_train = './data/motorbikes_train/';
elseif strcmp(type, 'test')
    air_train = './data/airplanes_test/';
    car_train = './data/cars_test/';
    face_train = './data/faces_test/';
    motor_train = './data/motorbikes_test/';
end

% get the filenames, same for every folder
dirInfo = dir(air_train); 
% remove directories
dirInfo = dirInfo(~[dirInfo.isdir]);

files = cell(size(dirInfo,1),1);
for K = 1:size(dirInfo,1)
  files{K} = dirInfo(K).name;
end

%features = zeros(num_samples*4,voc_size);
features = [];
count = 1;
if strcmp(type, 'train')
    ii = 251:250+num_samples;
else
    ii = 1:num_samples;
end

% 1 = airplanes
% 2 = cars
% 3 = faces
% 4 = motorbikes

for i=ii
    count
    % airplane
    im_air = imread(strcat(air_train,files{i}));
    if size(im_air,3) == 3 
        im_air = im2single(rgb2gray(im_air));
    else
        im_air = im2single(im_air);
    end
    [F_air,D_air] = vl_sift(im_air);
    % estimate the features from the vocabulary
    [d,I] = pdist2(voc, double(D_air'), 'euclidean', 'Smallest', 1);
    [elems, cent] = hist(I,voc_size);
    %features(count,:) = elems/sum(sum(elems));
    features(count,:) = elems/norm(elems,reg);
    if vis == 1
        figure(1)
        bar(cent, features(count,:))
    end
    count = count+1;
end
disp('finished for airplanes.')
for i=ii
    count
    % car
    try
        im_car = imread(strcat(car_train,files{i}));
        if size(im_car,3) == 3 
            im_car = im2single(rgb2gray(im_car));
        else
            im_car = im2single(im_car);
        end
        [F_car,D_car] = vl_sift(im_car);
        [d,I] = pdist2(voc, double(D_car'), 'euclidean', 'Smallest', 1);
        [elems, cent] = hist(I,voc_size);
        %features(count,:) = elems/sum(sum(elems));
        features(count,:) = elems/norm(elems,reg);
        if vis == 1
            figure(2)
            bar(cent, features(count,:))
        end
        count = count+1;
    catch err
        disp('maximum cars')
        break
    end
end
disp('finished for cars.')
for i=ii
    count
    % face
    try
        im_face = imread(strcat(face_train,files{i}));
        if size(im_face,3) == 3 
            im_face = im2single(rgb2gray(im_face));
        else
            im_face = im2single(im_face);
        end
        [F_face,D_face] = vl_sift(im_face);
        [d,I] = pdist2(voc, double(D_face'), 'euclidean', 'Smallest', 1);
        [elems, cent] = hist(I,voc_size);
        %features(count,:) = elems/sum(sum(elems));
        features(count,:) = elems/norm(elems,reg);
        if vis == 1
            figure(3)
            bar(cent, features(count,:))
        end
        count = count+1;
    catch err
        disp('maximum faces')
        break
    end
end
disp('finished for faces.')
for i=ii
    count
    % motorbike
    im_motor = imread(strcat(motor_train,files{i}));
    if size(im_motor,3) == 3 
        im_motor = im2single(rgb2gray(im_motor));
    else
        im_motor = im2single(im_motor);
    end
    [F_motor,D_motor] = vl_sift(im_motor);
    [d,I] = pdist2(voc, double(D_motor'), 'euclidean', 'Smallest', 1);
    [elems, cent] = hist(I,voc_size);
%     features(count,:) = elems/sum(sum(elems));
    features(count,:) = elems/norm(elems,reg);
    if vis == 1
        figure(4)
        bar(cent, features(count,:))
    end
%     features(count,end + 1) = 4;
    count = count+1;
  
end

size(features)

% save the features in a .mat file
if strcmp(type, 'train')
    s = strcat('features_',int2str(voc_size),'.mat');
    save(s,'features');
else
    s = strcat('features_test_',int2str(voc_size),'.mat');
    save(s,'features');
end



% im = im2single(rgb2gray(imread('./data/cars_train/img100.jpg')));
% % find the sift descriptor
% [F,D] = vl_sift(im);
% size(voc)
% % estimate the features from the vocabulary
% [d,I] = pdist2(voc, double(D'), 'euclidean', 'Smallest', 1);
% 
% features_im = voc(I,:);
% size(features_im)
% I;
% [elems, cent] = hist(I,size(voc,1));
% size(elems(1,:))
% figure(1)
% %features_im = elems/trapz(cent,elems);
% bar(cent,elems)
% size(features_im);
% figure(2)
% dx = diff(cent(1:2));
% bar(cent,elems/sum(elems*dx));

end