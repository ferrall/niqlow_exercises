#include "../../Documents/Github/niqlow/Steph/BLPMain.ox"

delta(theta2)
{
	decl deltanew deltaold deltafp v num den sjt;
	v = rann(20,1);
	deltanew = util;
	deltaold = zeros(nobs,1);
	deltafp = deltanew;

	while (norm(deltanew - deltaold) > 0.01)
	{
		deltaold = deltafp;
		num = zeros(nobs,1);
		den = zeros(nmkt,ns);
		sjt = zeros(nobs,1);
		share zeros(nobs,ns);

		for (i=0; i<(nobs+1); ++i)
		{
			for (j=1; j<(ns+1); ++j)
			{
				num[i][j] = exp(deltaold[i] + theta2[1]*v[j]*branded[i] + theta2[2]*income[i][j]*price[i];
			}
		}


		for (i=1; i<(nmkt+1); ++i)
		{
			for (j=1; j<(ns+1); ++j)
			{
				den[i][j] = sumr(num[(i*11)-10:i*11][j];
			}
		}
				
		for (i=1; i<(nobs+1); ++i)
		{
			for (j=1; j<(ns+1); ++j)
			{
				share[i][j] = num[i][j]/(1+den[(floor(i-1)/11)+1][j]);
			}
			sjt[i][] = (1/ns)*sumc(share[i][1:20];
		}

		deltanew = deltaold + lnshare - log(sjt);
		deltafp = deltanew
	}		
}