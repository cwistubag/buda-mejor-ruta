module Utils

def self.getNearestStation(station, stationsList, testedStationsList) 
    raise Exception.new  Constants::MSG_BAD_METHOD_CALL + " (getNearestStation)" if station.empty? || stationsList.empty?

    if station[:contiguous].length == 0
        #Se llega al ultimo nodo el cual no tiene conexiones posteriores por configuración
        return nil
    else 
        counter = 0
        counterNextStations = 0
        endedProcessing = false
        nearestStation = []
        nextStation = []
        pendingNextStationVisitingFlag = false

        #Se evalua el nodo posterior a retornar en funcion si fue visitado previamente
        while counter < station[:contiguous].length && !endedProcessing do
            nearestStation = getStationInfoById(station[:contiguous][counter][:id],stationsList)
            if testedStationsList.length == 0 || station[:contiguous].length == 1 || !checkIfStationWasVisited(nearestStation[:name], testedStationsList)
                endedProcessing = true
            elsif checkIfStationWasVisited(nearestStation[:name], testedStationsList)
                #Si el nodo fue visitado y tiene mas de una conexion, verifico si alguna de esas no ha sido visitada, por lo tanto, sigue siendo candidato.
                if nearestStation[:contiguous].length > 1
                    while counterNextStations < nearestStation[:contiguous].length do
                        nextStation = getStationInfoById(nearestStation[:contiguous][counterNextStations][:id],stationsList)
                        pendingNextStationVisitingFlag = true if !checkIfStationWasVisited(nextStation[:name], testedStationsList)
                        counterNextStations += 1
                    end
                    if pendingNextStationVisitingFlag 
                        pendingNextStationVisitingFlag = false
                        endedProcessing = true 
                    end
                end
            end
            counter += 1
            endedProcessing = true if counter == station[:contiguous].length
        end

        return nearestStation
    end
end

def self.checkIfStationWasVisited(station, visitedStationsList)
    raise Exception.new  Constants::MSG_BAD_METHOD_CALL + " (checkIfStationWasVisited)" if station.empty?

    counter = 0
    found = 0

    if !visitedStationsList.empty?
        while counter < visitedStationsList.length do
            found += 1 if visitedStationsList[counter][:path].include? station
            counter += 1
            break if found > 0
        end
    end

    return found > 0 ? true : false
end

def self.checkIfAllStationsWereVisited(initialStation,endStation,visitedStationsList, stationList)
        raise Exception.new  Constants::MSG_BAD_METHOD_CALL + " (checkIfAllStationsWereVisited)" if visitedStationsList.empty? || stationList.empty?

        counter = 0
        counterX = 0
        counterY = 0
        found = 0
        waysToNextStation = 0
        nextStation = []
        ended = false
        noMoreRoutes = false
    
        while counterX < stationList.length do
            while counterY < visitedStationsList.length do
                if visitedStationsList[counterY][:path].include? stationList[counterX][:name]
                    found += 1
                    break
                end
                counterY += 1
            end
            counterX += 1
            counterY = 0
        end

        #Si se generan las dos primeras rutas iguales, entonces no hay mas posibles.
        firstRoute = visitedStationsList[0]
        secondRoute = visitedStationsList[1]

        if firstRoute == secondRoute
            noMoreRoutes = true
        end

        #Si se generan más de dos rutas, pero las dos últimas son iguales, entonces no hay más posibles.
        if visitedStationsList.length > 2 
            lastRoute = visitedStationsList[-1]
            penultimateRoute = visitedStationsList[2]
            if lastRoute == penultimateRoute
                noMoreRoutes = true
            end
        end

        return found == stationList.length ? true : noMoreRoutes ? true : false
end


def self.getStationInfoByName(station,stationList) 
    raise Exception.new  Constants::MSG_BAD_METHOD_CALL + " (getStationInfoByName)" if stationList.empty?

    counter = 0
    found = 0

    while counter < stationList.length do
        if stationList[counter][:name] == station
            found = 1
            break
        end
        counter += 1
    end

    raise Exception.new  Constants::MSG_STATION_NOT_FOUND if found == 0
    return stationList[counter]
end

def self.getStationInfoById(stationId,stationList) 
    raise Exception.new  Constants::MSG_BAD_METHOD_CALL + " (getStationInfoById)" if stationList.empty?

    counter = 0
    found = 0

    while counter < stationList.length do
        if stationList[counter][:id] == stationId
            found = 1
            break
        end
        counter += 1
    end

    raise Exception.new  Constants::MSG_STATION_NOT_FOUND if found == 0
    return stationList[counter]
end

def self.validateArgs(arguments) 
    raise Exception.new Constants::MSG_INVALID_PARAMETERS if arguments.empty?

    if arguments.length != 3 && arguments.length != 4 
        raise Exception.new Constants::MSG_INVALID_PARAMETERS
    end

    if !arguments[0].include? ".json"
        raise Exception.new Constants::MSG_BAD_EXTENSION_FILE
    end

    if arguments[3] && (arguments[3].casecmp(Constants::PARAM_GREEN_SUBWAY) != 0 && arguments[3].casecmp(Constants::PARAM_RED_SUBWAY) != 0)
        raise Exception.new Constants::MSG_BAD_EXPRESS_SUBWAY_OPTION 
    end

    if arguments[1] == arguments[2]
        raise Exception.new Constants::MSG_INITIAL_STATION_EQUALS_END_STATION
    end
end

def self.selectBestPath(initialStation,endStation,pathList) 
    raise Exception.new Constants::MSG_BAD_METHOD_CALL + " (selectBestPath)" if pathList.empty?

    counter = 0
    lowerWeightIndex = 0
    lowerWeightValue = 99999
    uniquePathList = pathList.uniq

    while counter < uniquePathList.length do
        if uniquePathList[counter][:path].include? endStation
            if uniquePathList[counter][:weight] <= lowerWeightValue
                lowerWeightIndex = counter 
                lowerWeightValue = uniquePathList[counter][:weight]
            end
        end
        counter += 1
    end

    return uniquePathList[lowerWeightIndex][:path]
end

def self.validateJSON(jsonFile) 
    raise Exception.new Constants::MSG_BAD_METHOD_CALL + " (validateJSON)" if jsonFile.empty?

    jsonSchemaData = File.read("./utils/subwayConfigSchema.json")
    validateSchema = JSON.load(jsonSchemaData)
    validateData = JSON.load(jsonFile)

    raise Exception.new Constants::MSG_NOT_VALID_JSON if !JSON::Validator.validate(validateSchema, validateData)
end

end