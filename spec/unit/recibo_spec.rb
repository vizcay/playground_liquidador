# encoding: utf-8
require 'spec_helper'
require_relative '../../app/recibo'

describe Recibo do
  let(:legajo)    { double(:legajo) }
  let(:empleador) { double(:empleador) }

  subject(:recibo) { Recibo.new(legajo, empleador) }

  it 'tiene referencia a legajo & empleador' do
    expect(recibo.legajo).to    eq legajo
    expect(recibo.empleador).to eq empleador
  end

  context 'cuando no existen conceptos' do
    it '#total_remunerativo es 0' do
      expect(recibo.conceptos).to be_empty
      expect(recibo.total_remunerativo).to eq 0
    end
  end

  context 'cuando existen conceptos' do
    it 'suma #total_remunerativo' do
      recibo.conceptos << double(:concepto, remunerativo: 1000)
      recibo.conceptos << double(:concepto, remunerativo: BigDecimal.new('100.50'))
      expect(recibo.total_remunerativo).to eq BigDecimal.new('1100.50')
    end
  end

  context 'cuando el legajo es vendedor y categoria A' do
    it 'devuelve sueldo basico segun puesto & categoria' do
      expect(legajo).to receive(:puesto).and_return(:vendedor)
      expect(legajo).to receive(:categoria).and_return(:a)
      expect(recibo.calcular_sueldo_basico).to eq BigDecimal.new('8628.75')
    end
  end

  context 'cuando el legajo es maestranza y categoria B' do
    it 'devuelve sueldo basico segun puesto & categoria' do
      expect(legajo).to receive(:puesto).and_return(:maestranza)
      expect(legajo).to receive(:categoria).and_return(:b)
      expect(recibo.calcular_sueldo_basico).to eq BigDecimal.new('8500.40')
    end
  end

  context 'cuando la antiguedad es menor a un año' do
    it '#calcular_antiguedad es 0' do
      expect(legajo).to receive(:antiguedad).and_return(0)
      recibo.stub(:calcular_sueldo_basico) { BigDecimal('8500.4') }
      expect(recibo.calcular_antiguedad).to eq 0
    end
  end

  context 'cuando la antiguedad es 2 años' do
    it '#calcular_antiguedad es basico * antiguedad * 1%' do
      expect(legajo).to receive(:antiguedad).and_return(2)
      recibo.stub(:calcular_sueldo_basico) { BigDecimal('8500.4') }
      expect(recibo.calcular_antiguedad).to eq BigDecimal.new('170.01')
    end
  end
end

