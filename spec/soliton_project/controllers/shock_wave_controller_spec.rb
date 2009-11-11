require File.expand_path(File.join(
  File.dirname(__FILE__), '..', '..', 'spec_helper')
)

require 'soliton_project/controllers/shock_wave_controller'

describe SolitonProject::ShockWaveController do

  before(:each) do
    @shock_wave_controller = SolitonProject::ShockWaveController.new
  end
  
  it "should inherit from the SolitonProject::Controller class" do
    @shock_wave_controller.should be_a_kind_of(SolitonProject::Controller)
  end
  
  it "should redefine the initialize method" do
    @shock_wave_controller.private_methods(false).should include(
      "initialize"
    )
  end
  
  it "should redefine the generate_initial_condition method" do
    @shock_wave_controller.public_methods(false).should include(
      "generate_initial_condition"
    )
  end

end