-- Подключение монитора и вывод статуса

-- Поиск монитора
local function findMonitor()
    local sides = peripheral.getNames()
    for _, side in ipairs(sides) do
        if peripheral.getType(side) == "monitor" then
            return peripheral.wrap(side), side
        end
    end
    return nil, nil
end

-- Получаем монитор
local monitor, monitorSide = findMonitor()

-- Проверка наличия монитора
if not monitor then
    print("Error: monitor not found")
    return
end

print("Monitor connected: " .. monitorSide)

-- Очистка и настройка
monitor.clear()
monitor.setTextScale(1)

-- Вывод информации
monitor.setCursorPos(1, 1)
monitor.setTextColor(colors.yellow)
monitor.write("=== Storage System ===")

monitor.setCursorPos(1, 3)
monitor.setTextColor(colors.white)
monitor.write("Status: Online")

monitor.setCursorPos(1, 5)
monitor.setTextColor(colors.green)
monitor.write("Ready for transfer")

-- Вывод времени
monitor.setCursorPos(1, 7)
monitor.setTextColor(colors.lightGray)
local time = textutils.formatTime(os.time(), false)
monitor.write("Time: " .. time)

print("Display updated")