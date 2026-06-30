-- smooth_clock.lua
-- Часы на мониторе 2x2 с мягким градиентом день/ночь

-- === НАСТРОЙКИ ===
local sensorSide = "top"  -- датчик сверху компьютера
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

-- Подключение
local monitor = findMonitor()
if not monitor then
    print("Error: monitor not found")
    return
end

monitor.setTextScale(0.5)

-- Мягкие цвета для градиента (приглушённые, не режущие глаз)
local dayColors = {
    morning = {   -- 6:00-9:00 - мягкий розовый рассвет
        bg = colors.lightGray,     -- 0xF0E0D0 в реальности, но используем доступные
        time = colors.gray,
    },
    noon = {      -- 9:00-15:00 - спокойный бежевый день
        bg = colors.white,
        time = colors.lightGray,
    },
    evening = {   -- 15:00-18:00 - тёплый золотистый
        bg = colors.orange,
        time = colors.gray,
    },
    sunset = {    -- 18:00-21:00 - приглушённый закат
        bg = colors.brown,
        time = colors.orange,
    },
    night = {     -- 21:00-6:00 - мягкий тёмно-синий
        bg = colors.black,
        time = colors.lightBlue,
    }
}

-- Получение текущего часа
local function getCurrentHour()
    local rawTime = os.time()
    local timeString = textutils.formatTime(rawTime, false)
    local hours = string.match(timeString, "^(%d+):")
    
    if hours then
        return tonumber(hours)
    end
    
    -- Запасной метод
    return math.floor((rawTime / 1000) + 6) % 24
end

-- Выбор цветовой схемы по времени
local function getColorScheme()
    local hour = getCurrentHour()
    
    if hour >= 6 and hour < 9 then
        return dayColors.morning
    elseif hour >= 9 and hour < 15 then
        return dayColors.noon
    elseif hour >= 15 and hour < 18 then
        return dayColors.evening
    elseif hour >= 18 and hour < 21 then
        return dayColors.sunset
    else
        return dayColors.night
    end
end

-- Отрисовка часов
local function drawClock()
    local time = os.time()
    local timeString = textutils.formatTime(time, false)
    local day = os.day()
    local hour = getCurrentHour()
    local scheme = getColorScheme()
    
    -- Мягкий фон
    monitor.setBackgroundColor(scheme.bg)
    monitor.clear()
    
    -- Время
    monitor.setCursorPos(1, 1)
    monitor.setTextColor(scheme.time)
    monitor.write(timeString)
    
    -- День
    monitor.setCursorPos(1, 3)
    monitor.setTextColor(scheme.time)
    monitor.write(string.format("Day %d", day))
    
    -- Время суток текстом
    local timeOfDay = ""
    if hour >= 6 and hour < 9 then
        timeOfDay = "Morning"
    elseif hour >= 9 and hour < 15 then
        timeOfDay = "Noon"
    elseif hour >= 15 and hour < 18 then
        timeOfDay = "Evening"
    elseif hour >= 18 and hour < 21 then
        timeOfDay = "Sunset"
    else
        timeOfDay = "Night"
    end
    
    monitor.setCursorPos(1, 5)
    monitor.setTextColor(scheme.time)
    monitor.write(timeOfDay)
end

-- Запуск
print("Smooth clock started")
print("Press Ctrl+T to stop")

while true do
    drawClock()
    sleep(1)
end