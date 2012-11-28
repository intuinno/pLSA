tic 
close all

clear

%============================
% Custom input Parameters
%============================

q = 5;

numIteration = 10;

numLatentClass = 5; 



%============================

if matlabpool('size') == 0 
	
	matlabpool 

end

load 1Kratings

colormap('bone');

[numUser numMovie] = size(ratings);

movieRatings = zeros(numMovie ,2);
userRatings = zeros (numUser,2);

count = 0;

TempRating = 0;

for i =1:numMovie 
	
	for j = 1:numUser 

		if ratings(j,i) > 0 
			
			count = count+1;
			
			TempRating = TempRating + ratings(j,i);
		end
		
	end
	
	
	movieRatings(i,1) = count;
	
	movieRatings(i,2) = TempRating/count;
	
	count =0;
	TempRating =0;
end

for i =1:numUser 
	
	for j = 1:numMovie 

		if ratings(i,j) > 0 
			
			count = count+1;
			
			TempRating = TempRating + ratings(i,j);
		end
		
	end
	
	
	userRatings(i,1) = count;
	
	userRatings(i,2) = TempRating/count;
	
	count =0;
	TempRating =0;
	
	
end

meanUser = mean(ratings,2);

edges = [ 0 1 2 3 4 5];

n=histc(ratings,edges,2);

numRatingUser = n(:,2)+n(:,3)+n(:,4) + n(:,5) + n(:,6);

stdAll = std2(ratings);

VarUser = (var(ratings,0,2) + q*stdAll) ./ (numRatingUser + q);
stdUser = sqrt(VarUser);


%initialize Variables

Q = rand(numUser, numMovie, numLatentClass);

A = rand(numUser, numLatentClass);

B = sum(A,2);

C = ones(1,numLatentClass);

D = B * C;

Pzu = A ./ D;

M_yz = rand(numMovie, numLatentClass);

Std_yz = rand(numMovie, numLatentClass);


for i=1:numIteration 
	
	%calculateE;
	
	for countUser=1:numUser
		
		for countItem=1:numMovie
			
			down = 0;
			
			for countLC=1:numLatentClass
				
				up = Pzu(countUser,countLC) * gaussianPDF(ratings(countUser, countItem),M_yz(countItem, countLC),Std_yz(countItem,countLC));
				
				down = down + up;
			
			end
			
			for countLC=1:numLatentClass
				
				up = Pzu(countUser,countLC) * gaussianPDF(ratings(countUser, countItem),M_yz(countItem, countLC),Std_yz(countItem,countLC));
				
				 
				
				Q(countUser,countItem,countLC) = up/down;
				
			end
			
		end
		
		disp(countUser);
		
	end
	
	
	%calculate M
	
	%First Calculate M_yz
	
	for countItem=1:numMovie
		
		for countLC=1:numLatentClass

			up = 0; 
			down =0;

			for countUser = 1 : numUser

				up = up + ratings(countUser,countItem)*Q(countUser,countItem,countLC);
				down = down + Q(countUser,countItem,countLC);

			end

			M_yz(countItem,countLC) = up/down;


		end
		
	end
	
	%Second Calculate Std_yz
	
	for countItem=1:numMovie
		
		for countLC=1:numLatentClass

			up = 0; 
			down =0;

			for countUser = 1 : numUser

				up = up + (ratings(countUser,countItem)-M_yz(countItem,countLC))^2*Q(countUser,countItem,countLC);
				down = down + Q(countUser,countItem,countLC);

			end

			M_yz(countItem,countLC) = up/down;

			
		end
		
	end
	 
	 %Lastly Calculate Pzu

	for countUser=1:numUser

		down=0;
		
		for countLC=1:numLatentClass

			up = 0; 
			

			for countItem = 1 : numMovie

				up = up + Q(countUser,countItem,countLC);
				down = down + Q(countUser,countItem,countLC);

			end

			Pzu(countUser,countLC) = up;

			
		end
		
		Pzu(countUser,:) = Pzu(countUser,:) / down;

	end

	
	disp(i);
	
	%calculateM;
	%displayRisk;
	
end


toc

