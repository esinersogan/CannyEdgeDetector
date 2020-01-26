output1 = cannyedgedetection('cameraman.jpg');
output2 = cannyedgedetection('fruit-bowl.jpg');
output3 = cannyedgedetection('house.jpg');
output4 = cannyedgedetection('Lenna.png');
output5 = cannyedgedetection('woman.JPG');


figure, imshow(output1);
figure, imshow(output2);
figure, imshow(output3);
figure, imshow(output4);
figure, imshow(output5);


%For original image + edge detected images
% pairOfImages = [imread("cameraman.jpg"), output1]; 
% figure, imshow(pairOfImages);
% 
% pairOfImages2 = [rgb2gray(imread("fruit-bowl.jpg")), output2]; 
% figure, imshow(pairOfImages2);
% 
% pairOfImages3 = [rgb2gray(imread("house.jpg")), output3]; 
% figure, imshow(pairOfImages3);
% 
% pairOfImages4 = [rgb2gray(imread("Lenna.png")), output4]; 
% figure, imshow(pairOfImages4);
% 
% pairOfImages5 = [rgb2gray(imread("woman.JPG")), output5]; 
% figure, imshow(pairOfImages5);





