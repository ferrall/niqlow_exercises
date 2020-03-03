#include "aiyagari.h"

Eq::MPSys(){
	decl LtoK =  aggV[LL]/aggV[K];
	return	P::MPco .* LtoK.^P::MPexp - P::MPdep;
	}

Eq::Eq(){
	System("Eq",Nfactors);
	aggV = zeros(Nfactors,1);
	price = new StDeviations("p_",0,{"w","r"});
	Parameters(price);
	Load();	
    aggV[LL] = exp(0.5*sqr(P::sig)); // exp( 0.5/ ( 1-sqr(par[myrho]) ) );
	Volume=QUIET;	
}

Eq::Interface() {		//called after state space created
	vi = new ValueIteration();
	pred = new PathPrediction (0,vi, ErgodicDist); 
	pred->Tracking(UseLabel,Agent::A,Agent::e);	
	}

Eq::vfunc() {
	pred -> Predict(1,0);
	aggV[K] = pred.flat[0][Kcol];
	return MPSys() - CV(price);
	}

Eq::Report() {
	vfunc();
	println("Equilibrium Conditions at current prices:");
	Print("Aiyagari",0,TRUE);
	println("\n\n ******** Agent Decisions ********");
	DPDebug::outV();
	println("\n\n ******** Ergodic Means ********",pred.flat[0][1:]);
	println("\n\n implied savings rate: ",P::alpha * P:: deprec / (CV(price)[LL]+P::deprec), "reported : ",P::original_savings);
//    I::curg->StationaryDistribution();
//	println("Ergodic distribution: ",I::curg.Pinfinity');
	}
	
Agent::Build() {
	decl agrid = sqr(range(0,sqrt(20),0.1));
	Initialize(new Agent());					
		SetClock(Ergodic);	
		Actions(a = new ActionVariable("a",columns(agrid)));
		e = new Tauchen("e",N,M,0.0,P::sig*sqrt(1-sqr(P::rho)),P::rho);
		A = new LiquidAsset ( "A" , columns(agrid) , a )	;	
		a -> SetActual(agrid);						
		A -> SetActual(agrid);
		EndogenousStates(e,A);
	CreateSpaces(LogitKernel,30.0);
    SetDelta(P::delt);
	println(" Actual Asset Nodes ",agrid);
	println("Tauchen Transition Matrix. Column is current v, row is trans. prob. ",e.Grid');
	}


Agent::Earn(){				return CV(Eq::price)[LL]*exp(AV(e));	}

Agent::NetIncome() {  	   return AV(A)*(1+CV(Eq::price)[K]) + Earn() - AV(a);	}

Agent::FeasibleActions(){	return NetIncome() .>= 0.0;	}	

Agent::Utility(){ 		   return (1/P::muM1)*(NetIncome().^P::muM1 - 1) ;	}
