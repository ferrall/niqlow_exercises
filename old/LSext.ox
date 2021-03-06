#import "niqlow"
#include "C:/Users/freek/Documents/GitHub/niqlow/examples/LS.ox"



struct LSext : LS {
	static decl d,s,g,k,sch, E, female, skill, p, cost; 
	Utility();
	static Build();
	static Run();
	static Earn();
	static Use();
	FeasibleActions();
	Reachable(); 	
}

LSext::Build(){
	Initialize(1,new LSext());  
	LS::Build();  		
	female = new FixedEffect("g",2);
	skill= new RandomEffect("k",2);
	p = new LaggedAction("p",a); 			// Track action last period
	GroupVariables(skill,female);
	s = new BinaryChoice("s");
	E = new ActionCounter("sch",8,s);
	Actions(s);  
	EndogenousStates(E);
	CreateSpaces();
}

LSext::Earn(){
	return exp ( (  1 ~ AV(g) ~ CV(sch) ~ CV(m) ~ sqr(CV(m)) ~ AV(k) ~ AV(e) ) * CV(beta)  );
}

LSext::Utility(){
	decl u= CV(a)*Earn() + (1-CV(a)).*((1-CV(s))*b+	CV(s)*d + CV(p)*cost*CV(s) );			// If last period works, then incur cost of school this period 
	return u;
}

LSext::FeasibleActions(){
	return ! (CV(a).*CV(s));
}

LSext::Reachable(){
	return ( CV(E)+CV(m) <= I::t );
}

LSext::Run() { 
    Build();
	beta = 	<1;-2;10;2.5;-5.5;-1;2>;		// constant - female FE - schooling - exp - exp^2 - RE - shock  
    b = 2;												 
	d = 5;
	cost = -10;  							// Cost of switching school 				
    VISolve(FALSE);
    }	

LSext::Use() {
	if (!Flags::ThetaCreated) Run();
	SimulateOutcomes(2);
	ComputePredictions();
}




