#import "niqlow"
/* Nam:  since you moved this file you have to specify the path to  /niqlow/examples/LS.ox.  
  It can be the full path or relative using ../ Replace ??? below */
  #include "C:/Users/freek/Documents/GitHub/niqlow/examples/LS.ox"

// #include "C:\Users\freek\Documents\GitHub\niqlow\examples\LS.ox"  

struct LSext : LS {

static decl d,s,g,k,sch, E, female, skill, p, cost;   //LSext "inherits" variables from LS
		Utility();
	    static Build();
    static Run();
    static Earn();
    static Use();
	 FeasibleActions();  //this should not be static (tricky...hard to explain until you understand more
	 Reachable(); 	//this should not be static either
    }

LSext::Build(){
	Initialize(8,new LSext());   //Use tabs to indent code so beginnin/end of functions clear
	LS::Build();  		
	female = new FixedEffect("g",2);
	skill= new RandomEffect("k",2);
	p = new LaggedAction("p",a);
	GroupVariables(skill,female);
	s = new BinaryChoice("s");
	E = new ActionCounter("sch",8,s);
	Actions(s);  
	EndogenousStates(E);
	//skill and female already added to GroupVariables.  Don't add twice

CreateSpaces();
}

LSext::Earn(){
return exp ( (  1 ~ AV(g) ~ CV(sch) ~ CV(m) ~ sqr(CV(m)) ~ AV(k) ~ AV(e) ) * CV(beta)  );
}

LSext::Utility(){
//  Remember, a and s are not numbers they are objects.  Need to get their current values

decl u= CV(a)*Earn() + (1-CV(a)).*((1-CV(s))*b+CV(s)*d + (1-CV(p))*cost*CV(s) );  // try: if not go work, get b, 
//println(u);
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
    // beta = 1|zeros(6,1);//<1;0.8;-0.2;1.2;1.0;-0.1;0.2>;
	beta = 	<1;-2;1.2;2.5;-1.5;-1;2>; 
    b = 2;												 
	d = 5;
	cost = -1; 
    VISolve(FALSE);
    }	

LSext::Use() {
    if (!Flags::ThetaCreated) Run();
   SimulateOutcomes(2);
   ComputePredictions();
    }




