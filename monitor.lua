local monitor = peripheral.wrap("right")

-- Очистить экран
monitor.clear()

-- Установить масштаб текста
monitor.setTextScale(1)  -- от 0.5 до 5.0

-- Вывести текст
monitor.setCursorPos(1, 1)
monitor.write("Привет, мир!")

-- Цветной текст
monitor.setTextColor(colors.green)
monitor.setCursorPos(1, 3)
monitor.write("Система хранения готова")

-- Сбросить цвет
monitor.setTextColor(colors.white)