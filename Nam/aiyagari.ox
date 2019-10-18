#import "niqlow"
   
class Aiyagari : Bellman {
	static const decl agrid = <-2;0;2;4;6;8;10>;
	static decl a, A, e, beta, sig, mu, M, N, rho, Z, E, r, w, sigma;  
    Utility();			
    static Build();
    static Run();
    static Earn();
    static Use();
	FeasibleActions(); 
}

Aiyagari::Build() {
SetClock(NormalAging,3);
Actions(a = new ActionVariable("a",Z));
e = new Tauchen("e",N,M,mu,sig,rho);
A = new LiquidAsset ( "A" , Z , a )	;
a -> SetActual(agrid);				/* grid point on asset */
A -> SetActual(agrid);
EndogenousStates(e,A);
    SetDelta(0.95);
}

Aiyagari::FeasibleActions(){
//println("*** ",CV(a),a.actual," ",AV(A)*(1+r)," ",Earn());
//return a.actual .<= AV(A)*(1+r) + Earn();
return AV(a) .<= AV(A)*(1+r) + Earn();
}

Aiyagari::Earn(){
return w*exp(AV(e));
}

Aiyagari::Utility(){
 decl u =  ( AV(A)*(1+r) + Earn() - AV(a) ).^(1 - sigma) / (1 - sigma) ;
 if (I::t==2 && CV(e)==0 && CV(A)==	3)
 	println(AV(A)," ",AV(e)," ",Earn()," ",AV(a)',(AV(A)*(1+r) + Earn() - AV(a))',u');
// println(AV(e)');
// println(u);
return u; 					/*Sub out consumption from budget constraint*/ 
}

Aiyagari::Run(){ 
M = 2;
N = 5;											/* grid on labour shock */ 
mu = 0;	 										/* mean on AR shock */ 
sig = 0.2; 										/* std on AR shock */
rho = 0.9; 										/* persistence of AR shock */ 
Z = 7;  										/* number grid on asset */
r = 0.3;
w = 2;
sigma = 2; 										/* CRRA parameter */

Initialize(new Aiyagari());				 // here is the template for each point in a state-space. new LS(): create a "screwdriver". clone.
Build();									   // you create class, you send it to niqlow.
CreateSpaces();
VISolve();
} 