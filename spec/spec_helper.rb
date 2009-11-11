$LOAD_PATH.unshift File.expand_path(
  File.join(
    File.dirname(__FILE__), '..', 'lib')
  ) unless
  $LOAD_PATH.include?(File.join(File.dirname(__FILE__), '..', 'lib')) ||
  $LOAD_PATH.include?(File.expand_path(
    File.join(File.dirname(__FILE__), '..', 'lib'))
  )
  
require 'rubygems'
require 'test/unit'
require 'spec'