#import "niqlow"
#include "../../niqlow/examples/LS.ox"


struct LSext : LS {  
    static decl s, E, female, skill, d;
           Utility();
    static Build(); 
    static Run();
    static Earn();
    static Use();
	static FeasibleActions();
	static Reachable();
    }

LSext::Build() {
	Initialize(1.0, new LSext());
	LS::Build();
	s = new BinaryChoice("s");
	E = new ActionCounter("sch",8,s);
    female = new FixedEffect("g",2);
    skill = new RandomEffect("k",2);
    GroupVariables(/*skill,*/female);
	Actions(s);
	EndogenousStates(E);
	beta=<1.5;0.5;1.1;0.2;-0.02;1>;
	b=1.0;
	d=-10;
}

LSext::Earn(){
	decl x;
	x = 1 ~CV(female)~CV(E)~CV(m)~sqr(CV(m))~AV(e);
	return exp(x*CV(beta));
	}

LSext::Utility(){
	return CV(a)*Earn()+(1-CV(a))*b + CV(s)*d;
	}
	
LSext::Use() {
    if (!Flags::ThetaCreated) Run();
    SimulateOutcomes(2);
    ComputePredictions();
    }

LSext::FeasibleActions(){
	return !(CV(a).*CV(s));
	}
	
LSext::Reachable(){
	return CV(E)+CV(m)<=I::t;
	}

LSext::Run() {
    Initialize(1.0,new LS());
    Build();
    CreateSpaces();
    VISolve(FALSE);
    }
