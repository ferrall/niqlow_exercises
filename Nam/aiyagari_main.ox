#include "aiyagari.ox"

main(){
	decl econ, alg;
	econ = new Eq(); 
	alg = new OneDimRoot(econ);
	//DP::Volume=
	alg.Volume=LOUD;
	Eq::Interface();
	alg -> Iterate(0,0,1E-9);
//    econ->Report();
    }


