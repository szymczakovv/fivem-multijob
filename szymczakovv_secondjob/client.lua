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
		'default', GetCurrentResourceName(), 'bagol',
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