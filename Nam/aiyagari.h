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
	static decl agrid; 
	static decl a, A, e, beta, sig, mu, M, N, rho, Z, E, sigma, pred, vi;
    Utility();			
    static Build();
    static Run();
    static Earn();
    static Use();
	FeasibleActions();
}
