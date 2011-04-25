#ifndef COUPLEDDENSITYAUX_H
#define COUPLEDDENSITYAUX_H

#include "AuxKernel.h"


//Forward Declarations
class CoupledDensityAux;

template<>
InputParameters validParams<CoupledDensityAux>();

/** 
 * Coupled auxiliary value
 */
class CoupledDensityAux : public AuxKernel
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  CoupledDensityAux(const std::string & name, InputParameters parameters);

  virtual ~CoupledDensityAux() {}
  
protected:
  virtual Real computeValue();

  // Real density_fun(Real T);

  VariableValue & _temperature;
  VariableValue & _pressure;
  
  Real _input_density_water;
  bool _has_variable_density;
  Real _density_subroutine_val;
  

  
};

#endif //COUPLEDDENSITYAUX_H
