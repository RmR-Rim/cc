-- Обновляемые часы на мониторе
-- Монитор подключен не вплотную (через проводной модем)

-- Поиск монитора через модем
local function findRemoteMonitor()
    local peripherals = peripheral.getNames()
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "monitor" then
            return peripheral.wrap(name), name
        end
    end
    return nil, nil
end

-- Подключение монитора
local monitor, monitorName = findRemoteMonitor()

if not monitor then
    print("Error: monitor not found")
    print("Check wired modem connection")
    return
end

print("Monitor found: " .. monitorName)

-- Получаем размер монитора
local width, height = monitor.getSize()
print(string.format("Monitor size: %dx%d", width, height))

-- Настройка монитора
monitor.clear()
monitor.setTextScale(1)

-- Основной цикл часов
local function drawClock()
    -- Получаем текущее время
    local time = os.time()
    local timeString = textutils.formatTime(time, false)  -- 24-часовой формат
    
    -- Альтернативный формат (12-часовой)
    local timeString12 = textutils.formatTime(time, true)  -- 12-часовой формат с AM/PM
    
    -- Дата
    local day = os.day()
    local dateString = string.format("Day %d", day)
    
    -- Очистка
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    
    -- Заголовок
    monitor.setCursorPos(2, 2)
    monitor.setTextColor(colors.yellow)
    monitor.write("=== REMOTE CLOCK ===")
    
    -- Время (крупно)
    monitor.setCursorPos(3, 5)
    monitor.setTextColor(colors.lime)
    monitor.setTextScale(2)  -- крупнее для времени
    monitor.write(timeString)
    
    -- Сброс масштаба
    monitor.setTextScale(1)
    
    -- 12-часовой формат
    monitor.setCursorPos(3, 8)
    monitor.setTextColor(colors.white)
    monitor.write(timeString12)
    
    -- День
    monitor.setCursorPos(2, 10)
    monitor.setTextColor(colors.cyan)
    monitor.write(dateString)
    
    -- Нижняя строка статуса
    monitor.setCursorPos(1, height)
    monitor.setTextColor(colors.gray)
    monitor.write("Monitor: " .. monitorName)
end

-- Запуск обновления
print("Clock started. Press Ctrl+T to stop")
print("Updating every second...")

while true do
    drawClock()
    sleep(1)  -- обновление каждую секунду
end