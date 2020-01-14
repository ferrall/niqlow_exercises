#include "oxstd.h"

decl Omega, AA, BB, nbrn, ns, nmkt, nobs, X1, X2, Z, theta1,
		util, IP, VB, lnshare, W, theta2hat, theta2guess,dmap ;


delta(theta2)
{
	decl deltaold , num, denom, df, it;

	//df = denom = zeros(nobs,1);
	deltaold = 	util;
	it = 0;
	do {
		num = exp(deltaold + theta2[0]*VB + theta2[1]*IP);
	//	println(rows(num)," ",columns(num));
		denom = 1+aggregatec(num,nbrn);
		df = lnshare - log(meanr(num./(1+denom[dmap][])));
		deltaold += df;
		//println("|df|",norm(df),moments(df~num~denom));
	//	println(it," ",theta2," ",df');
	} while( (norm(df).>.001) && (++it<50) );
	return deltaold;
}
gmmreduced(theta2,af,g,h)
{
	decl theta1c , epsilon, dt2=delta(theta2);
	theta1c = AA*(BB*dt2);
	epsilon = dt2 - X1*theta1c;
	af[0] = -epsilon'*Omega*epsilon;
	println(af[0]);
	return !isnan(dt2);
}

loaddata()
{
	decl Data,i;

	Data = loadmat("BLP2.in7");

	ns = 5; nbrn=4; 

	nobs=rows(Data) ;
	  dmap=<>;
	for (i=0;i<	nobs/nbrn;++i)
		dmap |= constant(i,nbrn,1);

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
	
	 Omega = Z*W*Z';
	 BB = X1'*Omega;
	 AA = BB*X1;
}