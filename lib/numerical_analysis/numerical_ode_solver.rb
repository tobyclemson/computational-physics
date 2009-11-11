require 'rubygems'
require 'active_support'

require 'numerical_analysis/numerical_ode_solving_method'
require 'numerical_analysis/euler_method'
require 'numerical_analysis/leapfrog_method'
require 'numerical_analysis/rk4_method'

module NumericalAnalysis

  # Acts as a proxy to an object that numerically solves a first order ODE 
  # given by dy/dx = f(y,x).
  class NumericalODESolver
  
    # Initialises an instance of the NumericalODESolver class by creating an
    # instance of a NumericalODESolvingMethod subclass.
    # 
    # Instances are created by passing in a method identifier (an 
    # underscored string or symbol representing the name of the method 
    # class which is a subclass of NumericalODESolvingMethod) along with 
    # three (or four) parameters (in argument list order):
    # _initial_condition_::         an object containing the initial 
    #                               condition of the ODE, i.e., the initial 
    #                               value of y in the equation 
    #                               dy/dx = f(y,x).
    # _differential_function_::     an object that responds to :call that 
    #                               represents the differential equation, 
    #                               i.e., f(y,x) in the equation 
    #                               dy/dx = f(y,x).
    # _interval_::                  the interval between successive values
    #                               in the iterations of the numerical 
    #                               method.
    # _initial_independent_variable_value_::
    #                               optional, the initial value of the 
    #                               independent variable, 0.0 by default.
    def initialize(method, *parameters)
      available_methods = NumericalODESolvingMethod.subclasses
      camelcase_identifier = method.to_s.camelcase
      requested_method = self.class.parent.to_s + "::" + (
        camelcase_identifier =~ /Method$/ ? 
        camelcase_identifier : 
        camelcase_identifier + "Method"
      )
    
      @numerical_method = if available_methods.include?(requested_method)
        requested_method.constantize.new(*parameters)
      else
        raise ArgumentError, "'#{camelcase_identifier}' is not a " + 
          "supported method for the numerical solution of ODEs."
      end
    end
  
    # Allows any method that is defined on the instance of a 
    # NumericalODESolvingMethod subclass to be called on an instance of this
    # class so that this class effectively acts as a proxy to the method 
    # class.
    # 
    # Any method that is not defined on the method class is dealt with by a 
    # method_missing method further up the hierarchy (such that a 
    # NoMethodError is raised).
    def method_missing(method, *arguments)
      if @numerical_method.respond_to?(method)
        @numerical_method.send(method, *arguments)
      else
        super
      end
    end
  
  end

end