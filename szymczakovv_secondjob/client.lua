ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
	
	Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterCommand('selectjob', function()
	openJobMenu()
end)

RegisterCommand('setsecondjob', function(source, args, rawCommand)
	TriggerServerEvent('szymczakovv:setsecondjob', args[1], args[2], args[3])
end)

openJobMenu = function()
	ESX.UI.Menu.CloseAll()

    local elements = {}
	ESX.TriggerServerCallback('szymczakovv:getJobs', function(a,b, c)
		table.insert(elements, { label = 'Current Job: '..tostring(c)})
		table.insert(elements, { label = tostring(a), job = 'first' })
		table.insert(elements, { label = tostring(b), job = 'second' })
	end)

	Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'multijob',
		{
			title    = "Select Job",
			align	 = "bottom-right",
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('szymczakovv:setSecondJob', data.current.job)
		end,
	function(data, menu)
		menu.close()
	end)
end
