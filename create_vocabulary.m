function create_vocabulary(sample_images, voc_size)

% training sets
air_train = './data/airplanes_train/';
car_train = './data/cars_train/';
face_train = './data/faces_train/';
motor_train = './data/motorbikes_train/';

% % testing sets
% air_test = './data/airplanes_test/';
% car_test = './data/cars_test/';
% face_test = './data/faces_test/';
% motor_test = './data/motorbikes_test/';

% get the filenames, same for every folder
dirInfo = dir(air_train); 
% remove directories
dirInfo = dirInfo(~[dirInfo.isdir]);

files = cell(size(dirInfo,1),1);
for K = 1:size(dirInfo,1)
  files{K} = dirInfo(K).name;
end

D = [];
for i=1:sample_images
    i
    % airplane
    im_air = imread(strcat(air_train,files{i}));
    if size(im_air,3) == 3 
        im_air = im2single(rgb2gray(im_air));
    else
        im_air = im2single(im_air);
    end
    [F_air,D_air] = vl_sift(im_air);
    
    % car
    im_car = imread(strcat(car_train,files{i}));
    if size(im_car,3) == 3 
        im_car = im2single(rgb2gray(im_car));
    else
        im_car = im2single(im_car);
    end
    [F_car,D_car] = vl_sift(im_car);
    
    % face
    im_face = imread(strcat(face_train,files{i}));
    if size(im_face,3) == 3 
        im_face = im2single(rgb2gray(im_face));
    else
        im_face = im2single(im_face);
    end
    [F_face,D_face] = vl_sift(im_face);
    
    % motorbike
    im_motor = imread(strcat(motor_train,files{i}));
    if size(im_motor,3) == 3 
        im_motor = im2single(rgb2gray(im_motor));
    else
        im_motor = im2single(im_motor);
    end
    [F_motor,D_motor] = vl_sift(im_motor);
    
    % construct the descriptor matrix
    D = [D; D_air';D_car';D_face';D_motor'];
end
size(D)

% disp('Finished parsing the descriptors. Starting MoG...')
% [means,cov,prior] = vl_gmm(double(D'),voc_size, 'verbose');
% voc = means;
% size(voc)
% obj = gmdistribution.fit(double(D),voc_size);
% voc = obj.mu;

disp('Finished parsing the descriptors. Starting k-means...')
[voc, A] = vl_kmeans(double(D'),voc_size,'verbose', 'algorithm','ann','MaxNumIterations', 100);
size(voc)

% save the vocabulary in a .mat file
s = strcat('visual_vocabulary_',int2str(sample_images*4),'_',int2str(voc_size),'.mat');
save(s,'voc');

end