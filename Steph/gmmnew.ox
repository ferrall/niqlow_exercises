#include "oxstd.h"

decl Omega, AA, BB, nbrn, ns, nmkt, nobs, X1, X2, Z, theta1,
		util, IP, VB, lnshare, W, theta2hat, theta2guess ;


delta(theta2)
{
	decl deltaold , num, denom, df;

	df = denom = num = zeros(nobs,1);
	deltaold = 	util;
	do { 
		num[] = exp(deltaold + theta2[0]*VB + theta2[1]*IP);
		denom[] = 1+aggregatec(num,nbrn);
		df[] = lnshare - log(meanr(num./(1+denom)));
		deltaold += df;
	} while(norm(df).>.01);
	return deltaold;
}
gmmnew(theta2,af,g,h)
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
	lnshare = Data[][60];
	decl branded = Data[][67];
	decl income = Data[][2:21];
	decl price = Data[][25];
	decl v = rann(20,1);
	IP = income.*price;
	VB = v'.*branded;
	println("X1 ",moments(X1),"X2",moments(X2),"Z",moments(Z));

	 Omega = Z*W*Z';
	 BB = X1'*Omega;
	 AA = BB*X1;
}