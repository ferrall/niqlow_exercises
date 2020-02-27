#include "aiyagari.ox"

main(){
	decl econ, alg;
	econ = new Eq(); 
	alg = new NewtonRaphson(econ);
	alg.Volume=LOUD;
    Agent::Build();
	Eq::Interface();
	alg -> Iterate();
    econ->Report();
    }


