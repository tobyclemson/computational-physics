require File.expand_path(File.join(
  File.dirname(__FILE__), 'spec_helper')
)

require 'sparse_matrix'

describe SparseMatrix do
  
  before(:each) do
    @sparse_matrix = SparseMatrix.new
  end

  describe "instance interface" do

    it "should have a * method" do
      @sparse_matrix.should respond_to(:*)
    end

  end

  describe "class interface" do

    it "should have a [] method" do
      SparseMatrix.should respond_to(:[])
    end

  end

  describe "multiplication" do
    
    before(:each) do
      @sparse_matrix = SparseMatrix[[0,1,2], [2,0,3], [1,2,1], [0,2,5]]
      @vector = Vector[1,2,3]
    end

    it "should return the correct vector when multiplied by a vector" do
      @vector = (@sparse_matrix * @vector)
      @vector.should == Vector[19,3,3]
      @vector = (@sparse_matrix * @vector)
      @vector.should == Vector[21,3,57]
    end

  end

end