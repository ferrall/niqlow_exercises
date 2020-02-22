<<<<<<< HEAD
// #include "aiyagari.ox"
   #include "C:/Users/freek/Documents/GitHub/niqlow_exercises/Nam/aiyagari.ox"
main() {
=======
#include "aiyagari.ox"

main(){
	decl econ, alg;
	econ = new Eq(); 
	alg = new NewtonRaphson(econ);
	alg.Volume=LOUD;
>>>>>>> master
    Aiyagari::Run();
	alg -> Iterate();
    }


