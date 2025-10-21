%% filter the images (removes means and normalizes contrast).

% Set parameters
  N=[FILL IN HERE]; % BONUS TODO. Insert the number of pixels to use on shortest side of image.
  M=10;  % Number of images.
  
  image = zeros(N,N,M);
  
  % Name your images files myimage1.jpg, myimage2.jpg, etc. If they are not
  % jpg but another file format (e.g., png), change jpg to png on line 14
  % below. You may also change 'myimage' to a more descriptive filename if
  % you enter your replacement on line 15 below.

for k=1:M
    temp = imread(['myimage',num2str(k),'.jpg']); %
    image(:,:,k) = rgb2gray(temp((end-N+1):end,1:N,:));
    image(:,:,k) = image(:,:,k)-sum(sum(image(:,:,k)))/N^2; % remove mean
    image(:,:,k) = image(:,:,k)/std(reshape(image(:,:,k),N^2,1)); % normalize variance
end


%%
  [fx, fy]=meshgrid(-N/2:N/2-1,-N/2:N/2-1);
  rho=sqrt(fx.*fx+fy.*fy);
  f_0=0.4*N;
  filt=rho.*exp(-(rho/f_0).^4);
  
  IMAGES = zeros(N^2,M);

  for k=1:M
    If=fft2(image(:,:,k));
    imagew=real(ifft2(If.*fftshift(filt)));
    IMAGES(:,k)=reshape(imagew,N^2,1);
  end

  IMAGES=sqrt(0.1)*IMAGES/sqrt(mean(var(IMAGES)));
  
  % reshape images back to 2d arrys

     IMAGES = reshape(IMAGES,N,N,M); 


  save IMAGES_bonus IMAGES