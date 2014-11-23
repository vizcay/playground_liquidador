# encoding: utf-8

ESCALA = {
  vendedor: { a: BigDecimal.new('8628.75'), b: BigDecimal.new('8869.4'), c: BigDecimal.new('8949.63'), d: BigDecimal.new('9126.07') },
  auxiliar: { a: BigDecimal.new('8468.35') }
}.frozen

legajo               = Legajo.new
legajo.numero        = 25
legajo.nombre        = 'Pablo Vizcay'
legajo.cuil          = '23-31821972-9'
legajo.puesto        = :vendedor
legajo.categoria     = :a
legajo.fecha_ingreso = Date.new(2000, 1, 1) # legajo.antiguedad_anios

empleador            = Empleador.new
empleador.nombre     = 'De Monte Norberto'
empleador.domicilio  = 'Acapulco 770'
empleador.localidad  = '7609 Santa Clara del Mar'
empleador.cuit       = '20-11203411-1'
empleador.lugar_pago = 'Acapulco 770'

recibo           = Recibo.new
recibo.legajo    = legajo
recibo.empleador = empleador
recibo.periodo   = Periodo.new(10, 2014)
recibo.cargas_sociales_anteriores.fecha   = Date.new(2014, 9, 15)
recibo.cargas_sociales_anteriores.periodo = Periodo.new(9, 2014)
recibo.cargas_sociales_anteriores.banco   = 'Banco Provincia Bs. As.'

# novedades #
recibo.dias_inasistencias = 1.5
recibo.dias_vacaciones = 14
recibo.dias_licencia = 3

recibo.liquidar

recibo.conceptos # [concepto1, ..]

recibo.conceptos[0].codigo
recibo.conceptos[0].nombre
recibo.conceptos[0].cantidad
recibo.conceptos[0].remunerativo
recibo.conceptos[0].no_remunerativo
recibo.conceptos[0].descuento

recibo.total_remunerativo    # importes
recibo.total_no_remunerativo
recibo.total_descuentos
recibo.total_neto
recibo.total_neto_en_letras

class Concepto
  attr_accessor :codigo, :nombre, :cantidad, :remunerativo, :no_remunerativo, :descuento

  def initialize(codigo, nombre, valores)
    @codigo          = codigo
    @nombre          = nombre
    @cantidad        = valores[:cantidad]
    @remunerativo    = valores[:remunerativo]
    @no_remunerativo = valores[:no_remunerativo]
    @descuento       = valores[:descuento]
  end
end

class Recibo
  attr_accessor :legajo, :empleador, :periodo, :cargas_sociales_anteriores, :conceptos,
                :dias_inasistencias, :dias_licencia, :dias_vacaciones

  def initialize
    @conceptos = []
  end

  def liquidar
    @conceptos << Concepto.new(1, 'Sueldo básico',      remunerativo: calcular_sueldo_basico)
    @conceptos << Concepto.new(2, 'Antiguedad',         remunerativo: calcular_antiguedad)
    if @dias_inasistencias > 0
      @conceptos << Concepto.new(3, 'Dias inasistencias', remunerativo: calcular_inasistencias, cantidad: @dias_inasistencias)
    end
    @conceptos << Concepto.new(3, 'Jubilación',         descuento: calcular_jubilacion)
    @conceptos << Concepto.new(3, 'Obra Social',        descuento: calcular_obra_social)
  end

  def total_remunerativo
    @conceptos.select { |c| c.remunerativo }.inject(BigDecimal(0)) { |total, c| total += c.remunerativo }
  end

  def total_no_remunerativo
    @conceptos.select { |c| c.no_remunerativo }.inject(BigDecimal(0)) { |total, c| total += c.no_remunerativo }
  end

  def total_descuentos
    @conceptos.select { |c| c.descuento }.inject(BigDecimal(0)) { |total, c| total += c.descuento }
  end

  private

  def calcular_sueldo_basico
    ESCALA[@legajo.puesto][@legajo.categoria]
  end

  def calcular_antiguedad
    sueldo_basico * @legajo.antiguedad * BigDecimal('0.01')
  end

  def calcular_inasistencias
    -(sueldo_basico / BigDecimal(30) * @dias_inasistencias)
  end

  def calcular_jubilacion
    total_remunerativo * BigDecimal('.11')
  end

  def calcular_obra_social
    total_remunerativo * BigDecimal('.03')
  end
end

