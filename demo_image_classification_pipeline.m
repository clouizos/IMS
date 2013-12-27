% create the vocabulary from the first 50 images
create_vocabulary(50,400,'dense')

% find the features of the rest and create feature vectors
% training and testing
estimate_features(450,'train','dense',400,200,2,0);
estimate_features(50,'test','dense',400,200,2,0);

% perform the classification
svm_classify(400,200,'dense','rbf')