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
		println("num", "denom");
	} while(norm(df).>.01);
	return deltaold;
}
gmmreduced(theta2,af,g,h)
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

	Data = loadmat("BLP2.in7");

	ns = 5; nmkt = 300, nbrn=4; 

	nobs=rows(Data) ;

	X1 = Data[][<10:12, 27:31>];

	X2=Data[][<10, 26>];

	Z = Data[][<12, 14:23 ,36>];


	W = invertsym(Z'*Z);

	util = Data[][35];
	lnshare = Data[][25];
	decl branded = Data[][26];
	decl income = Data[][2:6];
	decl price = Data[][10];
	decl v = rann(5,1);
	IP = income.*price;
	VB = v'.*branded;
	println("X1 ",moments(X1),"X2",moments(X2),"Z",moments(Z), "W", moments(W));
	println("delta(theta2)")

	 Omega = Z*W*Z';
	 BB = X1'*Omega;
	 AA = BB*X1;
}