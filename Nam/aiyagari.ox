#import "niqlow"
   
class Aiyagari : ExtremeValue {
	static const decl agrid = <0;1;2;4;6;8;10>;/*grid point on asset */ 
	static decl a, A, e, beta, sig, mu, M, N, rho, Z, E, r, w, sigma, pred, vi;  
    Utility();			
    static Build();
    static Run();
    static Earn();
    static Use();
	FeasibleActions(); 
}

Aiyagari::Build() {
	SetClock(Ergodic);
	Actions(a = new ActionVariable("a",Z));
	e = new Tauchen("e",N,M,mu,sig,rho);
	e->Update();								/* from Christ, need to update Tauchen variable */   							
	A = new LiquidAsset ( "A" , Z , a )	;
	a -> SetActual(agrid);						
	A -> SetActual(agrid);
	EndogenousStates(e,A);
    SetDelta(0.95);
}

Aiyagari::FeasibleActions(){
	return a.actual .<= AV(A)*(1+r) + Earn();
	}

Aiyagari::Earn(){
	return w*exp(AV(e));
	}

Aiyagari::Utility(){
 	decl u =  ( AV(A)*(1+r) + Earn() - AV(a) ).^(1 - sigma) / (1 - sigma) ;
	return u; 									/*Sub out consumption from budget constraint*/ 
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
	Initialize(20.0, new Aiyagari());					
	Build();
	StorePalpha();
	CreateSpaces();
	VISolve();
	decl EMax = new ValueIteration(0);
	EMax -> Solve();
	I::curg->StationaryDistribution();
	println("Ergodic distribution: ",I::curg.Pinfinity);
	vi = new ValueIteration();
	pred = new PathPrediction(0,"agg",vi,ErgodicDist);  //ErgodicDist means use it as initial dist
	pred->Tracking(TrackAll);
	pred -> Predict(40,Two);  // only need 1 prediction(long run), Two means print out
}

