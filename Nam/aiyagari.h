#import "niqlow"

	enum{LL,K,Nfactors}
	enum{Kcol=2}

			//Table II, panel A, top row, middle column
struct P {
	static const decl 
	alpha  = 0.36,
	sig	   = 0.4,
	rho	   = 0.9,
	mu	   = 5,
	delt   = 0.96,
	deprec = 0.08,
	muM1   = 1-mu,
	lam    = (1-delt)/delt,
	alM1   = 1-alpha,
	MPco   = <alM1  ; alpha >,
	MPexp  = <-alpha; alM1>,
	MPdep  = <0;deprec>,
	original_r = 0.041456,
	original_savings = .2371;
	static Wage();
	}

struct Eq:OneDimSystem {
	static decl aggV, price, pred, vi,LtoK, MP ;
	Eq();
	static Interface();
	vfunc();
	Report();
	}

class Agent : ExPostSmoothing {
	static const decl
		M = 2.0,
		N = 7,
	    KSS = 40,
		kstep=0.05; 
	static decl a, A, e;
	FeasibleActions();
    Utility();			
    static Build();
	static NetIncome();
}
