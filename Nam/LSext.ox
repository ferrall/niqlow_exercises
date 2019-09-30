					 #import "niqlow"
#include "LS.ox"

struct LSext : LS {
static decl d,b,beta,a,m,e,s,g,k,sch, E, female, skill;
Utility();
	    static Build();
    static Run();
    static Earn();
    static Use();
	static FeasibleActions();
	static Reachable();
    }

LSext::Build(){
Initialize(1.0,new LSext());
LS::Build();
female = new FixedEffect("g",2);
skill= new RandomEffect("k",2);
GroupVariables(skill,female);
s = new BinaryChoice("s");
E = new ActionCounter("sch",8,s);
Actions(s);
EndogenousStates(E);
ExogenousStates(female,skill);
CreateSpaces();
}

LSext::Earn(){
return exp ( (  1 ~ AV(g) ~ CV(sch) ~ CV(m) ~ sqr(CV(m)) ~ AV(k) ~ AV(e) ) * CV(b)  );
}

LSext::Utility(){
return a*Earn() + (1-a)*((1-s)*b+s*d);
}

LSext::FeasibleActions(){
return ! CV(a).*CV(s);
}

LSext::Reachable(){
return CV(E)+CV(m) <= I::t;
}

LSext::Run() {
    Build();
    beta = <0.8;-0.2;1.2;1.0;-0.1;0.2>;							  
    b = 2;												 
	d = 0.2;
    VISolve(FALSE);
    }	






