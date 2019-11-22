#include "oxstd.h"

	decl Omega, AA, BB, v, ns, nmkt, nobs, X1, X2, Z, theta1, util, branded, income, price, lnshare, W, theta2hat, theta2guess ;


delta(theta2)
{
	decl deltanew , deltaold , deltafp , num, den , sjt, share,i,j;
	deltanew = util;
	deltaold = zeros(nobs,1);
	deltafp = deltanew;

	num = zeros(nobs,1);

	while (norm(deltanew - deltaold) > 0.01)
	{
	println(deltanew," ",deltaold);
		num[] = 0;
		deltaold = deltafp;
		den = zeros(nmkt,ns);
		sjt = zeros(nobs,1);
		share =zeros(nobs,ns);

		for (i=0; i<(nobs+1); ++i)
		{
			for (j=1; j<(ns+1); ++j)
			{
				num[i][j] = exp(deltaold[i] + theta2[1]*v[j]*branded[i] + theta2[2]*income[i][j]*price[i]);
			}
		}


		for (i=1; i<(nmkt+1); ++i)
		{
			for (j=1; j<(ns+1); ++j)
			{
				den[i][j] = sumr(num[(i*11)-10:i*11][j]);
			}
		}
				
		for (i=1; i<(nobs+1); ++i)
		{
			for (j=1; j<(ns+1); ++j)
			{
				share[i][j] = num[i][j]/(1+den[(floor(i-1)/11)+1][j]);
			}
			sjt[i][] = (1/ns)*sumc(share[i][1:20]);
		}

		deltanew = deltaold + lnshare - log(sjt);
		deltafp = deltanew;
	}
	return deltanew;
}
gmm(theta2,af,g,h)
{
	decl theta1c , epsilon;
	theta1c = AA*(BB*delta(theta2));
	epsilon = delta(theta2) - X1*theta1c;
	af[0] = -epsilon'*Omega*epsilon;
	return 1;
}

loaddata()
{
	decl Data;

	Data = loadmat("BLP.in7");
	
	ns = 20; nmkt = 3504; 

	nobs=rows(Data) ;

	X1 = Data[][<25:26, 50:78>];

	X2=Data[][<25, 67>];

	Z = Data[][<27, 29:58 ,65>];

	
	W = invertsym(Z'*Z);
	
	util = Data[][64];
	branded = Data[][67];
	income = Data[][2:21];
	lnshare = Data[][60];
	println("X1 ",moments(X1),"X2",moments(X2),"Z",moments(Z));
		v = rann(20,1);
	 Omega = Z*W*Z';
	 BB = X1'*Omega;
	 AA = BB*X1;
}
