
=begin 
***********************************************
Name:           main.rb
Version:        1.0
Created_by:     Carlos Wistuba G.
Date:           22/03/2021
Description:    Programa que selecciona entre una serie de nodos, la mejor ruta posible entre uno y otro.
*************************************************
=end

require 'json'
require './utils/Constants'
require './utils/Utils'
require 'json-schema'

begin
    #Validación de argumentos antes de proceder
    Utils.validateArgs(ARGV)

    #Preparación de variables y objeto que contendrá la configuración de las estaciones cargadas.
    testedPaths = [];
    visitedStations = [];
    subwayFile = ARGV[0]
    initialStation = ARGV[1].upcase
    endStation = ARGV[2].upcase
    expressFlag = ARGV[3]? ARGV[3] : false
    expressType = ARGV[3]
    noMorePaths = false
    processingStation = ""
    nearestStation = []
    nextNearestStation = []
    sumWeigth = 0
    processedPath = false
    subwayConfig = []
    subwayConfigConnectedStations = []
    subwayConfigFile = File.read(subwayFile)
    subwayConfigObject = JSON.parse(subwayConfigFile, object_class: OpenStruct)
    subwayConfigObject.data.map do |station| 
        stationWeight = (station.type == Constants::PARAM_GREEN_SUBWAY || station.type == Constants::PARAM_RED_SUBWAY) && (expressFlag) ? Constants::EXPRESS_WEIGHT : Constants::DEFAULT_WEIGHT
        if station.contiguous.length > 0 
            station.contiguous.map do |connectedStations|
                subwayConfigConnectedStations.push({ id: connectedStations.id })
            end
        end
        subwayConfig.push({ id: station.id, name: station.name.upcase, type: station.type, weight: stationWeight, contiguous: subwayConfigConnectedStations })
        subwayConfigConnectedStations = []
    end

    #Validación de esquema JSON
    Utils.validateJSON(subwayConfigFile)

    #Se obtienen los primeros datos obligatorios y luego se utiliza la lógica para ir evaluando proximos nodos.
    initialStationData = Utils.getStationInfoByName(initialStation,subwayConfig)
    endStationData = Utils.getStationInfoByName(endStation,subwayConfig)

    while !noMorePaths
        visitedStations.push(initialStationData[:name])
        nearestStation = Utils.getNearestStation(initialStationData,subwayConfig,testedPaths)
        raise Exception.new Constants::MSG_STATION_DISCONNECTED if nearestStation == nil
        visitedStations.push(nearestStation[:name]);
        sumWeigth += nearestStation[:weight];
        previousStationWasExpress = false
        while !processedPath do
            processingStation = visitedStations.last if !previousStationWasExpress
            if processingStation != endStation 
                processingStationData = Utils.getStationInfoByName(processingStation,subwayConfig)
                nextNearestStation = Utils.getNearestStation(processingStationData,subwayConfig, testedPaths) if !previousStationWasExpress
                if nextNearestStation == nil
                    processedPath = true
                elsif expressFlag
                    if nextNearestStation[:type].casecmp(expressType) == 0 || nextNearestStation[:type].casecmp(Constants::PARAM_NORMAL_SUBWAY) == 0
                        visitedStations.push(nextNearestStation[:name])
                        sumWeigth += nextNearestStation[:weight]
                        processingStation = nextNearestStation[:name]
                        previousStationWasExpress = false
                    else
                        nextNearestStation = Utils.getNearestStation(nextNearestStation,subwayConfig, testedPaths)
                        processingStation = nextNearestStation[:name]
                        previousStationWasExpress = true
                    end
                else
                    visitedStations.push(nextNearestStation[:name])
                    sumWeigth += nextNearestStation[:weight]
                    processingStation = nextNearestStation[:name]
                    previousStationWasExpress = false
                end
            else
                if previousStationWasExpress
                processingStationData = Utils.getStationInfoByName(endStation,subwayConfig)
                visitedStations.push(processingStationData[:name])
                sumWeigth += processingStationData[:weight]
                end
                processedPath = true
            end
        end

        # Ruta evaluada se almacena para posterior verificación
        testedPaths.push({:path=>visitedStations, :weight=>sumWeigth})

        if Utils.checkIfAllStationsWereVisited(initialStationData,endStationData,testedPaths,subwayConfig)
            noMorePaths = true
        else
            visitedStations = [];
            sumWeigth = 0;
            processedPath = false;
        end
    end

    #Una vez que se recorrieron las rutas posibles, se evalúa la mejor.
    bestRoute = Utils.selectBestPath(initialStation, endStation, testedPaths)
    puts "El camino más corto para llegar de '#{initialStation}' hasta '#{endStation}' es por la ruta : #{bestRoute}."

rescue Errno::ENOENT
    puts Constants::MSG_FILE_NOT_FOUND
rescue JSON::ParserError
    puts Constants::MSG_NOT_VALID_JSON
rescue Exception => e
    puts e.message
end