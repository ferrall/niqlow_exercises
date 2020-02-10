#include "aiyagari.h"

Eq::MPSys(){
	return
	   alpha*aggV[K]^(alpha-1)*aggV[LL]^(1-alpha) | (1-alpha)*aggV[K]^(alpha)*aggV[LL]^(-alpha);		// so l = sum over exp(z) 
}

Eq::Eq(){
	System("Eq",Nfactors);
	aggV = zeros(Nfactors,1);
	price = new StDeviations("p",0.8|0.5);
	Parameters(price);
	Load();
	Volume=QUIET;
	//ToggleParameterConstraint();
}

Eq::vfunc() {
	Aiyagari::pred -> Predict(1,0);	 						// don't wanna print it out: replace Two by Zero (or 0)		
	aggV[K] = Aiyagari::pred.flat[0][2];
	decl sig2 = 1/(1-sqr(CV(Aiyagari::rho)));
    aggV[LL] = exp(sig2/2);
	// aggV[LL] = exp(AV(e)) * Aiyagari::pred.flat[0][2]	;
	return	MPSys() - CV(price);
}

Aiyagari::Build() {
	SetClock(Ergodic);
	
	Actions(a = new ActionVariable("a",Z));
	e = new Tauchen("e",N,M,mu,sig,rho);
    println("Tauchen Transition Matrix. column is current, row is trans. prob. ",e.Grid');
    //  niqlow changed so this shouldn't be needed now because mu sig rho all constant:	e->Update();
	A = new LiquidAsset ( "A" , Z , a )	;
	
	a -> SetActual(agrid);						
	A -> SetActual(agrid);
	EndogenousStates(e,A);
    SetDelta(0.95);
}




Aiyagari::FeasibleActions(){
println("CV ",CV(Eq::price));
	return AV(a) .<= AV(A)*(1+CV(Eq::price)[K]) + Earn();
//	return a.actual .<= AV(A)*(1+r) + Earn();
	}

Aiyagari::Earn(){
/*	return CV(Eq::w)*exp(AV(e));  	*/
	return CV(Eq::price)[LL]*exp(AV(e));
	}

Aiyagari::Utility(){
/* 	decl u =  ( AV(A)*(1+CV(Eq::r)) + Earn() - AV(a) ).^(1 - sigma) / (1 - sigma) ;	  	*/
 	decl u =  ( AV(A)*(1+CV(Eq::price)[K]) + Earn() - AV(a) ).^(1 - sigma) / (1 - sigma) ;
	return u; 									/*Sub out consumption from budget constraint*/
	}

Aiyagari::Run(){
	M = 2;
	N = 5;											/* grid on labour shock */
	mu = 0;	 										/* mean on AR shock */
	sig = 0.2; 										/* std on AR shock */
	rho = 0.9; 										/* persistence of AR shock */
	agrid = range(-3,5,0.1);
	Z = columns(agrid);  										/* number grid on asset */
	sigma = 2; 										/* CRRA parameter */
	Initialize(20.0, new Aiyagari());					
	Build();
	CreateSpaces();
	vi = new ValueIteration(0);
	vi -> Solve();
	pred = new PathPrediction (0,vi, ErgodicDist);  //can change second 0 to vi for nested solution.
	pred->Tracking(UseLabel,a);
	
    // confirm stationarity ... print 3 predictions , Two means print out
	DPDebug::outV(TRUE);
    println("Checking if Pinfinity is correct. norm of delta: ", norm(I::curg.Ptrans*I::curg.Pinfinity - I::curg.Pinfinity));
}