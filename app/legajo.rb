# encoding: utf-8
require 'date'
require_relative 'core_ext'

class Legajo
  attr_accessor :nombre, :cuit, :fecha_nacimiento, :fecha_alta, :errors

  def initialize
    @errors = []
  end

  def edad
     @fecha_nacimiento.elapsed_years_since if @fecha_nacimiento
  end

  def antiguedad
     @fecha_alta.elapsed_years_since if @fecha_alta
  end

  def validate
    errors << ERR_NOMBRE_FALTANTE     if @nombre.nil? or @nombre.empty?
    errors << ERR_LARGO_NOMBRE        if @nombre and @nombre.length > 30
    errors << ERR_CUIT_FALTANTE       if @cuit.nil? or @cuit.empty?
    errors << ERR_MENOR_16            if not @fecha_nacimiento.nil? and edad < 16
    errors << ERR_FECHA_NAC_FALTANTE  if @fecha_nacimiento.nil?
    errors << ERR_FECHA_ALTA_FALTANTE if @fecha_alta.nil? or @fecha_alta.empty?
    errors.empty?
  end

  ERR_NOMBRE_FALTANTE     = 'debe especificar un nombre.'
  ERR_LARGO_NOMBRE        = 'el nombre no debe superar 30 caracteres.'
  ERR_CUIT_FALTANTE       = 'debe especificar un cuit.'
  ERR_MENOR_16            = 'la edad del legajo no puede ser inferior a 16 años.'
  ERR_FECHA_NAC_FALTANTE  = 'debe especificar la fecha de nacimiento.'
  ERR_FECHA_ALTA_FALTANTE = 'debe especificiar la fecha de alta.'
end

