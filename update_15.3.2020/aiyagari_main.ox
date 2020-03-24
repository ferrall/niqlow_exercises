#include "aiyagari.ox"

main(){
	decl econ, alg;
	econ = new Eq(); 
//	alg = new NewtonRaphson(econ);
	alg = new OneDimRoot(econ);
//	DP::Volume=alg.Volume=QUIET;
	DP::Volume=alg.Volume=LOUD;
	Eq::Interface();
	alg -> Iterate(0.1,0.1);
    econ->Report();
    }


