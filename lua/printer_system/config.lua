printerss = {}

printerss.MinPrice = 200 -- минимальная цена BP
printerss.MaxPrice = 550 -- максимальная цена BP

printerss.UltJobs = { -- работы, которые могут открывать меню принтера вне зависимости от дальности
    'Citizen',
    'Битмайнер',
}

printerss.VipRanks = { -- ранги, которые могут покупать радужный принтер
    ["Спонсор"]   = true,
    ["Представитель"] = true,
    ["Админ"] = true,
    ["Оператор"] = true,
    ["Куратор"] = true,
    ["Разработчик+"] = true,
    ["superadmin"] = true,
    ["Event-менеджер"] = true,
    ["MEMBER+"]   = true,
    ["Модератор"]   = true,
}

printerss.RechPrice = 3500 -- цена перезарядки в ЙЕН
printerss.InitHeat = 10 -- начальная температура
printerss.MaxTemp = 60 -- максимальная температура
printerss.ThrdTemp = 35 -- температура предупреждения

printerss.LimitForU = 5 -- лимит для всех профессий
printerss.LimitForJob = 7 -- лимит для вип работ

-- ЭТОТ КОНФИГ ВЛИЯЕТ ТОЛЬКО НА ОТОБРАЖЕНИЕ В МЕНЮ. САМ КОНФИГ ПРИНТЕРОВ НАХОДИТСЯ В ИХ ФАЙЛАХ entities/НАЗВАНИЕ/shared.lua

-- eprint_base НЕ ТРОГАТЬ, ЭТО БАЗА 

printerss.Printers = {
    {
        name = 'Янтарный принтер', -- Название принтера
        ent = 'yantar_printer', -- уникальное имя (англ)
        price = '3000', -- цена в Йенах
        model = 'models/animeworld/feromon/printer/printer_e.mdl', -- модель
        IsVIP = false, -- принтер для VIP?
        MoneyAmount = 1000, -- кол-во поинтов, которые он печатает
        TempAdd = 0.5, -- сколько градусов прибавляется
        Rechargeprice = 1000,
        PrinterHealth = 100 -- здоровье принтера
    },
    {
        name = 'Лазуритовый принтер', -- Название принтера
        ent = 'lazurite_printer', -- уникальное имя (англ)
        price = '5000', -- цена в Йенах
        model = 'models/animeworld/feromon/printer/printer_b.mdl', -- модель
        IsVIP = false, -- принтер для VIP?
        MoneyAmount = 2000, -- кол-во поинтов, которые он печатает
        TempAdd = 0.4, -- сколько градусов прибавляется
        Rechargeprice = 1500,
        PrinterHealth = 125 -- здоровье принтера
    },
    {
        name = 'Рубиновый принтер', -- Название принтера
        ent = 'rubin_printer', -- уникальное имя (англ)
        price = '10000', -- цена в Йенах
        model = 'models/animeworld/feromon/printer/printer_r.mdl', -- модель
        IsVIP = false, -- принтер для VIP?
        MoneyAmount = 3000, -- кол-во поинтов, которые он печатает
        TempAdd = 0.3, -- сколько градусов прибавляется
        Rechargeprice = 2500,
        PrinterHealth = 175 -- здоровье принтера
    },
    {
        name = 'Радужный принтер', -- Название принтера
        ent = 'rainbow_printer', -- уникальное имя (англ)
        price = '25000', -- цена в Йенах
        model = 'models/animeworld/feromon/printer/printer.mdl', -- модель
        IsVIP = false, -- принтер для VIP?
        MoneyAmount = 4000, -- кол-во поинтов, которые он печатает
        TempAdd = 0.1, -- сколько градусов прибавляется
        Rechargeprice = 4000,
        PrinterHealth = 250 -- здоровье принтера
    },
}
