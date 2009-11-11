require 'matrix'

class DimensionMismatchError < ArgumentError #:nodoc:
end

# The SparseMatrix class implements a Matrix where ony the non zero elements
# are stored and used in mathematical operations which greatly increases
# efficiency in the case where there are many zero elements in a matrix.
# 
# This class used the compressed row storage mechanism for sparse matrices.
class SparseMatrix
  
  class << self
    # Creates an instance of the SparseMatrix class with the supplied 
    # elements.
    def [](*elements)
      new(elements)
    end
  end
  
  # Initializes a SparseMatrix instance.
  def initialize(elements = [])
    @values = []
    @column_indices = []
    @row_pointers = []
    
    @row_pointers << 0
    current_pointer = 0
    row = 0
    elements.sort.each do |element|
      @values << element[2]
      @column_indices << element[1]
      if element[0] == row
        current_pointer += 1
      else
        (element[0] - row).times { @row_pointers << current_pointer }
        current_pointer +=1
        row = element[0]
      end
    end
    @row_pointers << current_pointer if elements.size > 0
  end
  
  # Performs matrix multiplication on _other_.
  # 
  # Currently only Vector arguments are supported.
  def *(other)
    case other
    when Numeric
      # TODO: Add scalar multiplication.
    when Vector
      # TODO: Fix dimensionality check
      #unless other.size == self.number_of_columns
      #  raise DimensionMismatchError
      #end
      
      vector_elements = []
      (0...other.size).each do |i|
        vector_elements[i] = 0
        row_start = @row_pointers[i]
        row_end = @row_pointers[i+1]
        (row_start...row_end).each do |index|
          vector_elements[i] += @values[index] * other[@column_indices[index]]
        end
      end
      
      return Vector.elements(vector_elements)
    when Matrix
      # TODO: Add matrix multiplication.
    else
      x, y = other.coerce(self)
      return x * y
    end
  end
  
end