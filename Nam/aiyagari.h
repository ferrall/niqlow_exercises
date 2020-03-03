#import "niqlow"

	enum{LL,K,Nfactors}
	enum{Kcol=2}

struct P {
	static const decl 
			//Table II, panel A, top row, middle column
	alpha  = 0.36,
	sig	   = 0.2,
	rho	   = 0.0,
	mu	   = 3.0,
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
	}

struct Eq:System {
	static decl aggV, price, pred, vi ;
	Eq();
	static Interface();
	static MPSys();
	vfunc();
	Report();
	}

class Agent : ExPostSmoothing {
	static const decl M = 3.0,		N = 7;  /* grid on labour shock */
	static decl a, A, e;
	FeasibleActions();
    Utility();			
    static Build();
    static Earn();
	static NetIncome();
}
