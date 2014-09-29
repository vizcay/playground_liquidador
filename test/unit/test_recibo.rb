# encoding: utf-8
require 'minitest/autorun'
require_relative '../../app/recibo'

class TestRecibo < Minitest::Unit::TestCase
  def setup
    @recibo = Recibo.new
  end
end

