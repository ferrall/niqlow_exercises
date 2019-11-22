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
	/*	num[] = 0; */
		deltaold = deltafp;
	/*	den = zeros(nmkt,ns);
		sjt = zeros(nobs,1);
		share =zeros(nobs,ns);	*/

		for (i=0; i=(ns-1); ++i)
		{
			num[][i] = deltaold + theta2[0].*v[i]*branded + theta2[1].*income[][i]*price
		}
		expnum=exp(num)
		v = range(1, 38535,11)
		for (i=0; i=(ns-1))
		{
		  sjtind[][i] = expnum./(1+sumr(expnum[v[i]:v[i]+10])
		 }	
		sjt = (1/ns).*sumc(sjtind)
		 
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
	
	ns = 20; nmkt = 3504, nbrn=11; 

	nobs=rows(Data) ;

	X1 = Data[][<25:26, 50:78>];

	X2=Data[][<25, 67>];

	Z = Data[][<27, 29:58 ,65>];

	
	W = invertsym(Z'*Z);
	
	util = Data[][64];
	branded = Data[][67];
	income = Data[][2:21];
	lnshare = Data[][60];
	price = Data[][25];
	println("X1 ",moments(X1),"X2",moments(X2),"Z",moments(Z));
		v = rann(20,1);
	 Omega = Z*W*Z';
	 BB = X1'*Omega;
	 AA = BB*X1;
}