function p = gaussianPDF (v, mean, std) 

	p = 1/sqrt(2*pi)/std*exp(-0.5*((v-mean)/std)^2);
	
end
