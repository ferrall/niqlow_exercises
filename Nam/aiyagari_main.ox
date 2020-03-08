#include "aiyagari.ox"

main(){
	decl econ, alg;
	econ = new Eq(); 
//	alg = new NewtonRaphson(econ);
	alg = new OneDimRoot(econ);
	DP::Volume=alg.Volume=QUIET;
	Eq::Interface();
//	alg -> Iterate(0.1,15);
    econ->Report();
    }


