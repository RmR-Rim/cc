-- direct_weather_clock.lua
-- Часы на мониторе 2x2 с датчиком сверху компьютера

-- === НАСТРОЙКИ ===
local sensorSide = "top"  -- датчик стоит сверху компьютера
-- =================

-- Поиск монитора
local function findMonitor()
    local peripherals = peripheral.getNames()
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "monitor" then
            return peripheral.wrap(name)
        end
    end
    return nil
end

-- Подключение монитора
local monitor = findMonitor()
if not monitor then
    print("Error: monitor not found")
    return
end

monitor.setTextScale(0.5)

-- Иконки погоды
local weatherIcons = {
    clear = "Clear",
    cloudy = "Cloudy", 
    rain = "Rain",
    thunder = "Storm",
    night = "Night",
    unknown = "No data",
}

-- Цветовые схемы
local function getColorScheme(weather)
    local schemes = {
        clear =   {bg = colors.white,     time = colors.black, weather = colors.orange},
        cloudy =  {bg = colors.lightGray, time = colors.black, weather = colors.yellow},
        rain =    {bg = colors.gray,      time = colors.white, weather = colors.blue},
        thunder = {bg = colors.black,     time = colors.red,   weather = colors.yellow},
        night =   {bg = colors.black,     time = colors.lime,  weather = colors.white},
        unknown = {bg = colors.black,     time = colors.red,   weather = colors.gray},
    }
    return schemes[weather] or schemes.night
end

-- Определение погоды
local function getWeather()
    local signal = rs.getAnalogInput(sensorSide)
    
    -- Если нет сигнала — датчик не подключен
    if signal == nil then
        return "unknown"
    end
    
    local time = os.time()
    local hours = tonumber(string.sub(textutils.formatTime(time, false), 1, 2))
    
    -- Ночью сигнал всегда 0
    if hours < 6 or hours > 18 then
        return "night"
    end
    
    -- Определение по уровню сигнала
    if signal >= 12 then
        return "clear"
    elseif signal >= 8 then
        return "cloudy"
    elseif signal >= 4 then
        return "rain"
    else
        return "thunder"
    end
end

-- Отрисовка на мониторе
local function drawClock()
    local time = os.time()
    local timeString = textutils.formatTime(time, false)
    local day = os.day()
    local weather = getWeather()
    local scheme = getColorScheme(weather)
    
    -- Фон
    monitor.setBackgroundColor(scheme.bg)
    monitor.clear()
    
    -- Время
    monitor.setCursorPos(1, 1)
    monitor.setTextColor(scheme.time)
    monitor.write(timeString)
    
    -- День
    monitor.setCursorPos(1, 3)
    monitor.setTextColor(scheme.weather)
    monitor.write(string.format("Day %d", day))
    
    -- Погода
    monitor.setCursorPos(1, 5)
    monitor.setTextColor(scheme.weather)
    monitor.write(weatherIcons[weather] or "No sensor")
end

-- Запуск
print("Weather clock started")
print("Sensor: top of computer")
print("Press Ctrl+T to stop")

while true do
    drawClock()
    sleep(1)
end