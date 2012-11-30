function p = gaussianPDF (v, mean, std) 

	if std ~= 0
		
		
		p = 1/sqrt(2*pi)*exp(-0.5*((v-mean)./std).^2) ./std;
	
	
	else 
		
		if abs(v - mean) < 0.00001 
			
			p = 1;
			
		else 
			
			p =0;
			
		end
		
	end
	
	
	
end
