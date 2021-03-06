require 'numerical_analysis/numerical_ode_solving_method'

module NumericalAnalysis

  # Encapsulates the Euler method for numerical first order ODE solution. An 
  # initial conditions vector is passed in along with a mathematical object 
  # (either a matrix or a lambda representing a mathematical function of the 
  # dependent and independent variables y and x) representing the 
  # differential function f(y,x) where dy/dx = f(y,x). The next value in the 
  # iteration is generated by calling the iterate method.
  class EulerMethod < NumericalODESolvingMethod
  
    # Iterates to the next value in the solution using the Euler method, e.g.:
    #
    #   y_next = y_current + interval * f(x_current, y_current)
    # 
    #   where f(x,y) is the function in the equation dy/dx = f(x,y),
    #         y is the dependent variable,
    #         x is the independent variable
    # 
    # Returns the resulting dependent variable value and the new independent 
    # variable value in the way defined in the NumericalODESolvingMethod.
    def iterate
      # Apply the Euler method to the current variable values to obtain the 
      # nextvalue.
      next_value = @current_dependent_variable_value + 
        @differential_function.call(
          @current_independent_variable_value,
          @current_dependent_variable_value
        ) * @interval
      
      # Set the dependent and independent variables to their new values.      
      @current_independent_variable_value += interval
      @current_dependent_variable_value = next_value
    
      # Call super to return the new values.
      super
    end
  
  end
  
end