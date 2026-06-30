-- Загрузчик файлов из репозитория
-- Использование: getfile <имя_файла> [сохранить_как]

local args = {...}

-- Проверка аргументов
if #args == 0 then
    print("Usage: getfile <filename> [save_as]")
    return
end

-- URL репозитория
local repoUrl = "https://raw.githubusercontent.com/RmR-Rim/CC/main/"
-- Замени username/repo/main на свои данные

local filename = args[1]
local saveAs = args[2] or filename  -- если второе имя не указано, сохраняем как оригинал
local fullUrl = repoUrl .. filename

-- Загрузка
print("Downloading: " .. filename)
shell.run("wget", fullUrl, saveAs)

-- Проверка результата
if fs.exists(saveAs) then
    print("Successfully saved as: " .. saveAs)
else
    print("Error: download failed")
end