#include "aiyagari.ox"

main(){
	decl econ, alg;
	econ = new Eq(); 
	alg = new NewtonRaphson(econ);
	alg.Volume=LOUD;
    Aiyagari::Run();
	alg -> Iterate();
    }


