#include "aiyagari.h"

Eq::Eq(){
	OneDimSystem("Eq_r"); //System("Eq",One);
	aggV = zeros(Nfactors,1);
	price = new array[Nfactors];
	price[K] = new BoundedAbove("r",0.5,0.03);
	price[LL] = new Determined("w",P::Wage);
	Parameters(price);
	Load();	
	Volume=QUIET;	
}

Eq::Interface() {		//called after state space created
	DP::Volume = SILENT;
	Agent::Build();
	vi = new ValueIteration();
	vi.vtoler = DIFF_EPS;
	pred = new PathPrediction (0,vi, ErgodicDist); 
	pred->Tracking(UseLabel,Agent::A,Agent::e);	
	}

P::Wage() {
	return alM1*( alpha/(CV(Eq::price[K])+deprec) )^(alpha/alM1);
	}

Eq::vfunc() {
	pred -> Predict(1,0);
    aggV[LL] = exp(0.5*sqr(P::sig)); // exp( 0.5/ ( 1-sqr(par[myrho]) ) );
	aggV[K] = pred.flat[0][Kcol];
	LtoK =  aggV[LL]/aggV[K];
	MP = P::MPco .* (LtoK.^P::MPexp) - P::MPdep;
	if (Volume>QUIET)
		println("System: ","%r",{"labor","capital"},"%c",{"MP","price"},MP~(CV(price)'));
	MP -= CV(price)';
	return MP[K];
	}

Eq::Report() {
	vfunc();
	println("\n\n ******** Agent Decisions ********");
	DPDebug::outV(TRUE,0,TRUE,TRUE,TRUE); //only print index of max not CCPs
	println("Equilibrium Conditions at current prices:");
	Print("Aiyagari",0,TRUE);
	println("\n\n ******** Ergodic Means ********",pred.flat[0][1:]);
	println("\n\n implied savings rate: ",P::alpha * P:: deprec / (CV(price[K])+P::deprec), " reported : ",P::original_savings);
	}
	
Agent::Build() {
	decl agrid = sqr(range(0,sqrt(KSS),kstep));
	Initialize(new Agent());					
		SetClock(Ergodic);	
		Actions(a = new ActionVariable("a",columns(agrid)));
		e = new Tauchen("e",N,M,0.0,P::sig*sqrt(1-sqr(P::rho)),P::rho);
		A = new LiquidAsset ( "A" , columns(agrid) , a )	;	
		a -> SetActual(agrid);						
		A -> SetActual(agrid);
		EndogenousStates(e,A);
	CreateSpaces(LogitKernel,30.0); 		//
    SetDelta(P::delt);//
	if (Volume>QUIET) {
		println(" Actual Asset Nodes ",agrid);
		println("Tauchen Transition Matrix. Column is current v, row is trans. prob. ",e.Grid');
		}
	}


Agent::NetIncome() {  	   return AV(A)*(1+CV(Eq::price[K])) +  CV(Eq::price[LL])*exp(AV(e)) - AV(a);	}

Agent::FeasibleActions(){	return NetIncome() .>= 0.0;	}	

Agent::Utility(){ 		   return (1/P::muM1)*(NetIncome().^P::muM1 - 1) ;	}
