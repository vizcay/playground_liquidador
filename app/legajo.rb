# encoding: utf-8

class Legajo
  attr_accessor :nombre, :cuit, :fecha_nacimiento, :fecha_alta, :errors

  def initialize
    @errors = []
  end

  def edad
    return nil unless @fecha_nacimiento
    now = Time.now.to_date
    now.year - @fecha_nacimiento.year -
      ((now.month > @fecha_nacimiento.month || (now.month == @fecha_nacimiento.month && now.day >= @fecha_nacimiento.day)) ? 0 : 1)
  end

  def antiguedad
    return nil unless @fecha_alta
    now = Time.now.to_date
    now.year - @fecha_alta.year -
      ((now.month > @fecha_alta.month || (now.month == @fecha_alta.month && now.day >= @fecha_alta.day)) ? 0 : 1)
  end

  def validate
    errors << ERR_NOMBRE_FALTANTE if @nombre.nil? or @nombre.empty?
    errors << ERR_LARGO_NOMBRE    if @nombre and @nombre.length > 30
    errors << ERR_CUIT_FALTANTE   if @cuit.nil? or @cuit.empty?
    errors << ERR_MENOR_16        if not @fecha_nacimiento.nil? and edad < 16
    errors.empty?
  end

  ERR_NOMBRE_FALTANTE = 'debe especificar un nombre.'
  ERR_LARGO_NOMBRE    = 'el nombre no debe superar 30 caracteres.'
  ERR_CUIT_FALTANTE   = 'debe especificar un cuit.'
  ERR_MENOR_16        = 'la edad del legajo no puede ser inferior a 16 años.'
end

