function output = cannyedgedetection(filename);
    I = imread(filename);
    if (numel(size(I))) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    Igray = double(Igray);
    
    %Padding for 5*5 Gaussian Filter
    Igray(1,:) = 0; 
    Igray(2,:) = 0; 
    Igray(size(Igray,1),:) = 0;
    Igray(size(Igray,1)-1,:) = 0;
    Igray(:,1) = 0;
    Igray(:,2) = 0;
    Igray(:,size(Igray,2)) = 0;
    Igray(:,size(Igray,2)-1) = 0;
    
    %Gaussian Filter
    sigma = 1.4;
    dim = 2;
    [x,y]=meshgrid(-dim:dim,-dim:dim);
    ex = -(x.^2+y.^2)/(2*sigma*sigma);
    kernel= exp(ex)/(2*pi*sigma*sigma);
    
    grad=zeros(size(Igray));
    
    for i=3:size(Igray,1)-2
        for j=3:size(Igray,2)-2
            sum = 0;
            for k=1:5
                for l=1:5
                    sum = sum + kernel(k,l)*Igray(i-3+k,j-3+l);
                end
            end
            grad(i,j)=sum;
        end
    end
    
    grad = uint8(grad);
    
    Idouble = double(grad);
    angles = zeros(size(Idouble, 1), size(Idouble, 2));
    
    siz = size(Idouble);
    
    %Sobel Filter
    Sx = [-1,0,1; -2,0,2; -1,0,1];
    Sy = [1,2,1; 0,0,0; -1,-2,-1];
    
    for i=2:size(Idouble,1)-2
        for j=2:size(Idouble,2)-2
           Gx=0;
           Gy=0;
           for k=1:size(Sx,1)
               for l=1:size(Sx,1)
                   Gx = Gx + (Sx(k,l)*Idouble(i-2+k,j-2+l));
                   Gy = Gy + (Sy(k,l)*Idouble(i-2+k,j-2+l));
               end
           end
           grad(i,j)=sqrt(Gx.^2+Gy.^2);
           angles(i,j) = atan2d(Gy,Gx); 
        end
    end
    
    %figure, imshow(grad);
    
    %Non-max suppression
    s = size(angles);
    temp = zeros(s(1), s(2));
    for i=2:s(1)-1
        for j=2:s(2)-1
            if angles(i,j) < 0 %handle negative angles
               angles(i,j) = angles(i,j) + 180;
            end
            %angle 0
            if (angles(i,j) < 22.5) || (angles(i,j) >= 157.5)
                q = grad(i, j+1);
                r = grad(i, j-1);
            %angle 45
            elseif (angles(i,j) < 67.5)
                q = grad(i+1, j-1);
                r = grad(i-1, j+1);
            %angle 90
            elseif (angles(i,j) < 112.5)
                q = grad(i+1, j);
                r = grad(i-1, j);
            %angle 135
            elseif (angles(i,j) < 157.5)
                q = grad(i-1, j-1);
                r = grad(i+1, j+1);
            end
            if (grad(i,j) >= q) && (grad(i,j) >= r)
                temp(i,j) = grad(i,j);
            else
                temp(i,j) = 0;
            end
        end
    end
                    
    grad = temp/max(temp(:));
    
    %figure, imshow(grad);
    
    highThreshold = (max(temp(:)) * 0.2);
    lowThreshold = highThreshold * 0.03;
    
    out = zeros(size(temp));
    
    weak = 25;
    strong = 255;
    
    for i=1:siz(1)
        for j=1:siz(2)
            if temp(i,j) > highThreshold
                out(i,j) = strong;
            elseif temp(i,j) < lowThreshold
                out(i,j) = 0;
            else
                out(i,j) = weak;
            end
        end
    end
    
    %figure, imshow(result);
    
    for i=2:siz(1)
        for j=2:siz(2)
            if (out(i,j) == weak)
                if (out(i+1, j-1) == strong) || (out(i+1, j) == strong) || (out(i+1, j+1) == strong) || (out(i, j-1) == strong) || (out(i, j+1) == strong) || (out(i-1, j-1) == strong) || (out(i-1, j) == strong) || (out(i-1, j+1) == strong)
                    out(i, j) = strong;
                else
                    out(i, j) = 0;
                end
            end
        end
    end 
    
    output = out;
end