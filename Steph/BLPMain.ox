#import <database>

main()
{
	decl Data = loadmat("PS1_Data/OTCnew.xlsx")

	decl dbase;
	dbase = new Database();
	dbase.load("/users/stephassad/Desktop/Empirical Methods/PS1_Data/OTCnew.xlsx")
	dbase.Info();

	delete dbase; /* ??? */
	
	decl ns, nmkt, nobs, X1, X2, Z, theta1, util, branded, income, price, lnshare, W, theta2hat, theta2guess

	ns = 20; nmkt = 3504; nobs = 38544; 
	theta2guess = <0.7, 0.08>
	
	X1 = zeros(nobs,13); X2 = zeros(nobs,2); Z = zeros(nobs,32) ;
	X1[][1:2] = Data[][26:27];
	X1[][3:13] = Data[][69:79];
	X2[][1] = Data[][26];
	X2[][2] = Data[][68];
	Z[][1] = Data[][28];
	Z[][2:31] = Data[][30:59];
	Z[][32] = Data[][66]
	
	W = (1/Z'*Z);
	
	util = Data[][65];
	branded = Data[][68];
	income = Data[][3:22]
	lnshare = Data[][61]
	
}