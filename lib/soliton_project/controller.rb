require 'rubygems'
require 'active_support'

module SolitonProject
  # The SolitonProject::Controller class is an abstract class from which 
  # the more specific controller classes inherit. It provides the 
  # functionality required to input parameters, initialise and run one of the 
  # SolitonProject::EquationSolver derivates and output the resulting
  # data to file.
  class Controller
    
    # Contains the default parameters used in running the equation solver.
    class_inheritable_hash :default_parameters
    
    # Set those default parameters that can be set at this level.
    self.default_parameters = {
      :x_interval => 0.1,
      :t_interval => 0.001,
      :number_of_temporal_points => 1000,
      :number_of_spatial_points => 200,
    }
    
    # Initialises an instance of the SolitonProject::Controller class.
    # 
    # Derivative classes need to call super if they overwrite initialize
    # and also define the equation_solver_class instance variable.
    def initialize
      @parameters = self.class.default_parameters
    end
    
    # Executes this controller by asking for the required parameters to be
    # input, generating the initial condition, creating and executing the
    # equation solver and outputting the results.
    def run
      input_parameters
      generate_initial_condition
      solve_equation
      output_results
    end
    
    # Asks the user to modify the default parameters, if necessary, and 
    # stores the resulting parameters in the parameters instance method.
    def input_parameters
      # Sort the default parameters alphabetically.
      sorted_default_parameters = 
        self.class.default_parameters.to_a.sort do |a, b|
          a[0].to_s <=> b[0].to_s
        end
      
      # Generate a menu using the default parameters.
      parameter_list = []
      parameter_mapping = {}
      
      sorted_default_parameters.each_with_index do |param, index|
        menu_item = index + 1
        parameter_list << "\t#{menu_item}: #{param[0].to_s} = #{param[1]}"
        parameter_mapping[menu_item.to_s] = param[0]
      end
      
      # Ask the user to update the parameters.
      print(
        "\nThe default parameters for the chosen problem are given below.\n" + 
          "Enter the corresponding menu item number to change a " + 
          "parameter.\n" +
          "Enter -1 when you have finished editing the parameters.\n" +
            parameter_list.join("\n") + "\n" +
            "Enter menu item number: "
      )
      
      while (choice = gets.chomp) && (choice != '-1')
        if choice == '-1'
          break
        else
          unless (choice =~ /^\d+$/) && (choice.to_i <= @parameters.size)
            print("Error: please enter only available menu choices!\n")
            exit
          end

          print("Enter new value for '#{parameter_mapping[choice].to_s}': ")

          new_value = gets.chomp

          begin
            current_value = @parameters[parameter_mapping[choice]]
            new_value = if current_value.kind_of?(Integer)
                Integer(new_value)
              elsif current_value.kind_of?(Float)
                Float(new_value)
              else
                raise ArgumentError
            end 
          rescue ArgumentError
            print("Error: please enter only numeric values!\n")
            exit
          end

          @parameters[parameter_mapping[choice]] = new_value

          print("\t#{parameter_mapping[choice].to_s} = #{new_value}\n")

          print("Enter menu item number: ")
        end
      end
    end
    
    # Generates a Vector instance representing the initial state of the
    # system.
    # 
    # For this abstract class, this method just raises a NotImplementedError.
    def generate_initial_condition
      raise NotImplementedError
    end
    
    # Creates and executes an instance of one of the 
    # SolitonProject::EquationSolver derivates as defined in the 
    # equation_solver_class instance variable
    def solve_equation
      print("\nGenerating data...\n")
      @equation_solver = @equation_solver_class.new(
        @initial_condition,
        @parameters[:number_of_temporal_points] - 1,
        @parameters[:x_interval],
        @parameters[:t_interval]
      )
      @equation_solver.setup
      @equation_solver.solve
    end
    
    # Outputs the results to a file with a file name that is unique with 
    # respect to the supplied parameters.
    def output_results
      problem_type = self.class.to_s.gsub(
        /.*\:\:/, ''
      ).gsub(
        'Controller', ''
      ).underscore
      
      parameter_list = @parameters.collect do |param, value, store|
        (store ||= "") << "#{param}, #{value}\n"
      end
      
      file_name = "#{problem_type}_#{Time.now.to_i}.csv"
      file_path = File.join(
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..')),
        "data",
        file_name
      )
      
      File.open(file_path, 'w') do |f|
        f.write(parameter_list)
        (0...@parameters[:number_of_spatial_points]).each do |space_point|
          f.write(", #{space_point * @parameters[:x_interval]}")
        end
        @equation_solver.data.each do |result|
          f.write("\n")
          f.write([result[0], *result[1].to_a].join(', '))
        end
      end
      
      print(
        "\n\nSuccess: data saved to " + 
          "data/#{file_name}\n\n"
      )
    end
    
  end
end