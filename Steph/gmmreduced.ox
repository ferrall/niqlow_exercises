#include "oxstd.h"
#import "database"

decl Omega, AA, BB, CC, nbrn, ns, nmkt, nobs, X1, X2, Z, ZZ, theta1,
		util, IP, VB, lnshare, W, theta2hat, theta2guess,dmap ;


delta(theta2)
{			
	decl deltaold , num, denom, df, it;

	//df = denom = zeros(nobs,1);
	deltaold = 	util;
	it = 0;
	do {
		num = exp(deltaold + theta2[0]*VB + theta2[1]*IP);
		denom = 1+aggregatec(num,nbrn);
	//	println(rows(denom)," ",columns(denom));
		df = lnshare - log(meanr(num./(1+denom[dmap][])));
	//	println("df ",rows(selectr(df)));
		deltaold += df;
		//println("|df|",norm(df));//moments(df~num~denom)
	//	println(it," ",theta2," ",df');
	} while( (norm(df).>.0001) && (++it<50) );
///	println(it," ",norm(df));
	return deltaold;
}
gmmreduced(theta2,af,g,h)
{
	//	println("** ",theta2');
	if (any(theta2.<0.0)||any(theta2.>80)) return 0;
	decl theta1c , epsilon, dt2=delta(theta2);
	theta1c = CC*(BB*dt2);
	epsilon = dt2 - X1*theta1c;
	//println(epsilon);
	af[0] = -epsilon'*Omega*epsilon;
	//println(af[0]);
	return !isnan(dt2);
}

myload()
{
	decl Data,i;

	Data = new Database();
	Data -> Load("gmm_var1.xlsx");//"BLP3.in7");

	ns = 3; nbrn=3; 

	nobs=Data->GetSize() ;
	Data->Info();
	  dmap=<>;
	for (i=0;i<	nobs/nbrn;++i)
		dmap |= constant(i,nbrn,1);

	X1 = Data->GetVar({"price_","prom_","brand1","brand4","brand7"}); 

	X2=Data->GetVar({"price_","branded"});

	Z = Data->GetVar({"cost_","avoutprice","pricestore1","pricestore2","pricestore3"});
	ZZ = Z'*Z;
	W = invert(ZZ);
	W = ZZ^(-1);
	decl sign;
	println(ZZ,W,logdet(ZZ,&sign)," sign ",sign);
	//println("Z",Z,"ZZ", ZZ,"W", W);

	util = Data->GetVar({"util"});
	lnshare = Data->GetVar({"lnshare"});
	decl branded = Data->GetVar({"branded"});
	decl income = Data->GetVar({"hhincome1","hhincome2","hhincome3"});
	decl price = Data->GetVar({"price_"});
	decl v = rann(3,1);
	IP = income.*price;
	VB = v'.*branded;
//	println("VB", VB);
	//println("Z",moments(Z), "W", moments(W));
	
	 Omega = Z*W*Z';
//	 println("Omega ",Omega);
	 BB = X1'*Omega;
	 AA = BB*X1;
	 CC = invert(AA);
	 println("BB ",BB," X1",X1,"Omega ",Omega);
}