module NumericalAnalysis

  # The NumericalODESolvingMethod class is an abstract class from which all
  # numerical methods should inherit.
  class NumericalODESolvingMethod
  
    # The interval between independent variables.
    attr_accessor :interval
  
    attr_reader   :current_dependent_variable_value, 
                  :current_independent_variable_value
                
    # Allows an object containing a :call method that is a function of the 
    # independent and dependent variables to be set so that a stability 
    # factor can be calculated for the current values.
    attr_accessor :stability_condition_function
  
    # Initialises an instance of the NumericalODESolvingMethod class. 
    # 
    # The _initial_condition_ parameter contains the initial value of the 
    # dependent variable. It can be any object that responds to basic 
    # mathematical operators (i.e., +, -, *, /).
    # 
    # The _differential_function_ parameter represents the function f(x,y) 
    # in the equation dy/dx = f(x,y). It can be any object that responds to 
    # :call and returns an object that responds to basic mathematical 
    # operators (i.e., +, -, *, /). The call to :call is passed the current 
    # values of the independent and dependent variables.
    # 
    # The _interval_ parameter determines the interval between successive 
    # independent variable values.
    # 
    # The optional _initial_independent_variable_value_ parameter is the 
    # starting value of the independent variable and is set to 0.0 by 
    # default.
    def initialize(
      initial_condition, 
      differential_function, 
      interval,
      initial_independent_variable_value = 0.0
    )
      @initial_independent_variable_value = 
        initial_independent_variable_value
      @current_independent_variable_value = 
        initial_independent_variable_value
  
      @initial_condition = initial_condition
      @current_dependent_variable_value = initial_condition
    
      @differential_function = differential_function
    
      self.interval = interval
    end
  
    # Iterates the numerical method to the next values for the dependent
    # variables, returning an array containing the resulting dependent 
    # variable value and the current value of the independent variable.
    # 
    # For this abstract class, all the method does is return the initial 
    # values of each of the variables.
    def iterate
      return [
        @current_independent_variable_value,
        @current_dependent_variable_value
      ]
    end
  
    # Resets the method to the initial conditions by setting the 
    # dependent variable value to the initial condition passed in at 
    # initialisation and setting the independent variable value to either 
    # the initial independent variable value passed in at initialisation or 
    # zero.
    def reset
      @current_independent_variable_value = 
        @initial_independent_variable_value
      @current_dependent_variable_value = @initial_condition
    end
  
    # Returns true if the method is operating in a stable manner, false 
    # otherwise.
    def stable?(stability_threshold = 0.01)
      return false unless factor = stability_factor
      return (factor - 1).abs < stability_threshold
    end
  
    # Calculates and returns the stability factor for the current dependent 
    # and independent variable values. 
    # 
    # This method relies on the the stability_condition_function which is an 
    # object that responds to :call containing a function of the dependent 
    # and independent variables. The call to :call is passed the current 
    # independent and dependent variable values.
    # 
    # The stability factor is the result of evaluating the 
    # stability_condition_function. A result of 1 +/- epsilon (0.01 by 
    # default) is required for the method to be considered stable. Any 
    # object assigned to the stable_condition_function should take this into
    # account.
    def stability_factor
      unless stability_condition_function
        raise RuntimeError, "No stability condition function has been set."
      end
    
      return stability_condition_function.call(
        @current_independent_variable_value,
        @current_dependent_variable_value
      )
    end
  
  end
  
end