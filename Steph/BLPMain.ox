#import <database>

main()
{
	decl Data = loadmat("PS1_Data/OTCnew.xlsx")  //this loads the data as a matrix

	decl dbase;        //this is not needed since you already loaded it directly
	dbase = new Database();
	dbase.load("/users/stephassad/Desktop/Empirical Methods/PS1_Data/OTCnew.xlsx")
	dbase.Info();

	delete dbase; /* ??? */   //The reason to use Database is lets you select columns using column labels.
	
	// by deleting the object you lose that info.  Data still in "Data"  BUt if you used dbase you wouldn't need to use column indices below
	
	decl ns, nmkt, nobs, X1, X2, Z, theta1, util, branded, income, price, lnshare, W, theta2hat, theta2guess

	ns = 20; nmkt = 3504; 
	// These values can be derived: nobs = 38544;     I.E. 
	nobs=rows(Data) 
	theta2guess = <0.7, 0.08>
	
	// X1 = zeros(nobs,13); X2 = zeros(nobs,2); Z = zeros(nobs,32) ;
	// you don't have to define the vectors first.  For example:
	X1 = Data[][<26:27, 60:79>];
	
	//Here is how you might use column labels in the spreadsheet if you used dbase (made up labels!):
	X1 = dbase->GetVar({"Ind","ID","Size"});
	
	//X1[][1:2] = Data[][26:27];  Please look for "matrix constants" and "indexing matrix and array types" in Ox Help
	//X1[][3:13] = Data[][69:79];
	X2=Data[][<26 68>];
	//X2[][1] = Data[][26];
	//X2[][2] = Data[][68];
	Z = Data[][<28 30:59 66>;
	//Z[][1] = Data[][28];
	/Z[][2:31] = Data[][30:59];
	//Z[][32] = Data[][66]
	
	W = (1/Z'*Z);
	
	util = Data[][65];
	branded = Data[][68];
	income = Data[][3:22]
	lnshare = Data[][61]
	
}
