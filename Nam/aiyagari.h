#import "niqlow"
enum{LL,K,Nfactors}
struct Eq:System{
	static const decl alpha = 0.4;
	static const decl z = 1; 
	static decl  aggV, price ;
	Eq();
	static MPSys();
	vfunc();
}
class Aiyagari : ExtremeValue {
	//static const decl agrid = <0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9>;/*grid point on asset */
	static decl agrid; 
	//<0.2;0.22;0.24;0.26;0.28;0.30;0.32;0.34;0.36;0.38>;/*grid point on asset */
	static decl a, A, e, beta, sig, mu, M, N, rho, Z, E, sigma, pred, vi;
	// static const decl aagrid = range(-3,5,0.1);
    Utility();			
    static Build();
    static Run();
    static Earn();
    static Use();
	FeasibleActions();
}


// Hieracy of stuff: LiquidAsset. Specify number of values
// range(-3,5,0.1) ; 0.1 is the step (this is ox function)
