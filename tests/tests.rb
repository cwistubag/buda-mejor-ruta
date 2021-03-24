require 'minitest/autorun'
require './utils/Constants'

class BudaMejorRutaAppTest < Minitest::Test
  @@mainExecutable = "main.rb"
  @@argumentFile = ""
  @@argumentInitialStation = ""
  @@argumentEndStation = ""
  @@argumentSubwayExpressType = ""

    def test_parametros_incorrectos
      @@argumentFile = ""
      @@argumentInitialStation = ""
      @@argumentEndStation = ""
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_INVALID_PARAMETERS, testResult
    end

    def test_archivo_no_existente
      @@argumentFile = "./subwayConfig/nada.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "B"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_FILE_NOT_FOUND, testResult
    end

    def test_archivo_no_json
      @@argumentFile = "./subwayConfig/nada.txt"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "B"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_BAD_EXTENSION_FILE, testResult
    end

    def test_archivo_json_no_valido
      @@argumentFile = "./tests/test.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "B"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_NOT_VALID_JSON, testResult
    end

    def test_estacion_inicial_invalida
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "Z"
      @@argumentEndStation = "A"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_STATION_NOT_FOUND, testResult
    end

    def test_estacion_final_invalida
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "Z"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_STATION_NOT_FOUND, testResult
    end

    def test_ruta_express_invalida
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "B"
      @@argumentSubwayExpressType = "beta"
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_BAD_EXPRESS_SUBWAY_OPTION, testResult
    end

    def test_ruta_corta
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "C"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\"]."
      assert_equal stringResult, testResult
    end

    def test_ruta_normal
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "F"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\", \"D\", \"E\", \"F\"]."
      assert_equal stringResult, testResult
    end

    def test_ruta_express_roja
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "F"
      @@argumentSubwayExpressType = "rojo"
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\", \"H\", \"F\"]."
      assert_equal stringResult, testResult
    end

    def test_ruta_express_verde
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "F"
      @@argumentSubwayExpressType = "verde"
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\", \"G\", \"I\", \"F\"]."
      assert_equal stringResult, testResult
    end

    def test_ruta_mediana
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "D"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\", \"D\"]."
      assert_equal stringResult, testResult
    end

    def test_ruta_estacion_inicial_igual_a_final
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "A"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_INITIAL_STATION_EQUALS_END_STATION, testResult
    end

    def test_ruta_estacion_inicial_sin_conexiones
      @@argumentFile = "./tests/test-estacion-sin-conexion.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "B"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_STATION_DISCONNECTED, testResult
    end

    def test_minusculas_nombre_estacion
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "a"
      @@argumentEndStation = "d"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation.upcase}' hasta '#{@@argumentEndStation.upcase}' es por la ruta : [\"A\", \"B\", \"C\", \"D\"]."
      assert_equal stringResult, testResult
    end

    def test_mayusculas_tipo_tren
      @@argumentFile = "./subwayConfig/estaciones-metro.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "F"
      @@argumentSubwayExpressType = "ROJO"
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\", \"H\", \"F\"]."
      assert_equal stringResult, testResult
    end

    def test_json_esquema_invalido
      @@argumentFile = "./tests/test-esquema-invalido.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "C"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      assert_equal Constants::MSG_NOT_VALID_JSON, testResult
    end

    def test_configuracion_metro_alternativa
      @@argumentFile = "./tests/estaciones-metro-alternativa.json"
      @@argumentInitialStation = "A"
      @@argumentEndStation = "F"
      @@argumentSubwayExpressType = ""
      testResult = executeProgram(@@mainExecutable,[@@argumentFile,@@argumentInitialStation,@@argumentEndStation,@@argumentSubwayExpressType])
      stringResult = "El camino más corto para llegar de '#{@@argumentInitialStation}' hasta '#{@@argumentEndStation}' es por la ruta : [\"A\", \"B\", \"C\", \"D\", \"X\", \"F\"]."
      assert_equal stringResult, testResult
    end

end

def executeProgram(executable,arguments)
  argument1 = arguments[0]
  argument2 = arguments[1]
  argument3 = arguments[2]
  argument4 = arguments[3]
  executionResult = %x( ruby #{executable} #{argument1} #{argument2} #{argument3} #{argument4})
  return executionResult.chomp
end