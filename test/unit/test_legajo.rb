# encoding: utf-8
require 'minitest/autorun'
require_relative '../../app/legajo'

class TestLegajo < Minitest::Unit::TestCase
  def setup
    @legajo = Legajo.new
  end

  def test_nombre_presence
    @legajo.nombre = nil
    @legajo.validate
    assert(@legajo.errors.include? Legajo::ERR_NOMBRE_FALTANTE)
  end

  def test_nombre_max_30
    @legajo.nombre = 'x' * 31
    @legajo.validate
    assert(@legajo.errors.include? Legajo::ERR_LARGO_NOMBRE)
  end

  def test_cuit_presence
    @legajo.cuit = nil
    @legajo.validate
    assert(@legajo.errors.include? Legajo::ERR_CUIT_FALTANTE)
  end

  def test_fecha_nacimiento_presence
    skip
  end

  def test_fecha_alta_presence
    skip
  end

  def test_calcula_edad
    @legajo.fecha_nacimiento = Date.new(1985, 10, 8)
    assert_equal(29, @legajo.edad)
    @legajo.fecha_nacimiento = Date.new(1990, 12, 13)
    assert_equal(23, @legajo.edad)
  end

  def test_calcula_antiguedad
    @legajo.fecha_alta = Date.new(2014, 1, 1)
    assert_equal(0, @legajo.antiguedad)
    @legajo.fecha_alta = Date.new(2013, 8, 1)
    assert_equal(1, @legajo.antiguedad)
    @legajo.fecha_alta = Date.new(2009, 1, 1)
    assert_equal(5, @legajo.antiguedad)
  end

  def test_fecha_nacimiento_menor_16
    @legajo.fecha_nacimiento = Date.new(2000, 1, 1)
    @legajo.validate
    assert(@legajo.errors.include? Legajo::ERR_MENOR_16)
  end
end

