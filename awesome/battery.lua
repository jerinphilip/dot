local battery = {}
local power_supply = '/sys/class/power_supply/'

function battery.charging(adapter_name)
    local adapter_file_name = power_supply..adapter_name..'/online'
    local adapter_file = io.open(adapter_file_name)
    local adapter_status = adapter_file:read()
    adapter_file.close()
    return (adapter_status == "1")
end

function battery.percent(battery_name)
    local stats = {}
    local battery_file_name = power_supply..battery_name..'/capacity'
    local battery_file = io.open(battery_file_name)
    local charge_level = battery_file:read()
    return tonumber(charge_level)
end

return battery
