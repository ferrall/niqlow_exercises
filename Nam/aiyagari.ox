#import "niqlow"

class Aiyagari : ExtremeValue {
	static const decl agrid = <0;1;2;4;6;8;10>;		/*grid point on asset */
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
    println("Tauchen Transition Matrix. column is current, row is trans. prob. ",e.Grid');
    //  niqlow changed so this shouldn't be needed now because mu sig rho all constant:	e->Update();
	A = new LiquidAsset ( "A" , Z , a )	;
	a -> SetActual(agrid);						
	A -> SetActual(agrid);
	EndogenousStates(e,A);
    SetDelta(0.95);
}

Aiyagari::FeasibleActions(){
	//return AV(a) .<= AV(A)*(1+r) + Earn();
	return a.actual .<= AV(A)*(1+r) + Earn();
	}

Aiyagari::Earn(){
	return w*exp(AV(e));
	}

Aiyagari::Utility(){
 	decl u =  ( AV(A)*(1+r) + Earn() - AV(a) ).^(1 - sigma) / (1 - sigma) ;
	return u; 										/*Sub out consumption from budget constraint*/
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
	CreateSpaces();
	vi = new ValueIteration(0);
	vi -> Solve();
	DPDebug::outV(TRUE);
    println("Checking if Pinfinity is correct. norm of delta: ", norm(I::curg.Ptrans*I::curg.Pinfinity - I::curg.Pinfinity));
	pred = new PathPrediction (0,"EY", 0, ErgodicDist);  //can change second 0 to vi for nested solution.
	pred->Tracking(TrackAll);
    // confirm stationarity ... print 3 predictions , Two means print out
	pred -> Predict(10,Two);
}
