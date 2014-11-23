# encoding: utf-8
require 'bigdecimal'
require_relative 'core_ext'

class Recibo
  attr_accessor :legajo, :empleador, :conceptos

  ESCALA = {
    maestranza: { b: bigdec('8500.40') },
    vendedor:   { a: bigdec('8628.75'), b: bigdec('8869.4'), c: bigdec('8949.63'), d: bigdec('9126.07') }
  }

  def initialize(legajo, empleador)
    @legajo    = legajo
    @empleador = empleador
    @conceptos = []
  end

  def total_remunerativo
    @conceptos.inject(BigDecimal.new(0)) { |total, concepto| total += concepto.remunerativo }
  end

  def calcular_sueldo_basico
    ESCALA[@legajo.puesto][@legajo.categoria]
  end

  def calcular_antiguedad
    (calcular_sueldo_basico * @legajo.antiguedad * BigDecimal.new('0.01')).round(2)
  end
end

