ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local JobNameLabel = {}
local JobList = {}

CreateThread(function()
	LoadJobs()
	JobLabels()
end)

RegisterServerEvent('szymczakovv:setSecondJob')
AddEventHandler('szymczakovv:setSecondJob', function(job)
	local _source = source
    	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local value = {
		first_job = SelectJob(xPlayer.getIdentifier(), 1),
		second_job = SelectJob(xPlayer.getIdentifier(), 2),
		
		first_jobgrade = SelectJob(xPlayer.getIdentifier(), 3),
		second_jobgrade = SelectJob(xPlayer.getIdentifier(), 4)
	}
	
	if job == 'first' then
		xPlayer.setJob(value.first_job, value.first_jobgrade)
		UpdateJobsDB(xPlayer.getIdentifier(), value.second_job)
	else
		xPlayer.setJob(value.second_job, value.second_jobgrade)
		UpdateJobsDB(xPlayer.getIdentifier(), value.first_job)
	end
end)

UpdateJobsDB = function(license, val)
	MySQL.Async.execute('UPDATE users SET secondjob = @secondjob WHERE identifier = @license',
	{
		['@license'] = license,
		['@secondjob'] = val
	})
end

LoadJobs = function()
	local PreJobList = {}
	
	local _source = source
    	local xPlayer = ESX.GetPlayerFromId(_source)
    	MySQL.Async.fetchAll('SELECT identifier, secondjob, secondjob_grade, job, job_grade FROM users', {}, function(player)
		for i=1, #player, 1 do
			table.insert(PreJobList, {
				license = tostring(player[i].identifier),
				secondjob = tostring(player[i].secondjob),
				secondjobgrade = tostring(player[i].secondjob_grade),
				job = tostring(player[i].job),
				jobgrade = tostring(player[i].job_grade),
			})
		end

		while (#PreJobList ~= #player) do
			Citizen.Wait(10)
		end

		JobList = PreJobList
	end)
end

SelectJob = function(license, what)
	for i=1, #JobList, 1 do
		local job = JobList[i]
		if ((tostring(job.license)) == tostring(license)) then 
			if what == 1 then
				return job.job
			elseif what == 2 then
				return job.jobgrade
			elseif what == 3 then
				return = job.secondjob
			elseif what == 4 then
				return = job.secondjobgrade
			end
		end
	end
end

JobLabels = function()
	local PreJobNameLabel = {}
	
	MySQL.Async.fetchAll("SELECT name, label FROM jobs", {}, function(result)
		for i=1, #result, 1 do
			table.insert(PreJobNameLabel, {
				name = tostring(result[i].name),
				label = tostring(result[i].label),
			})
		end
		
		JobNameLabel = PreJobNameLabel
	end)
end

CheckJobLabel = function(name)
	for i=1, #JobNameLabel, 1 do
		local job = JobNameLabel[i]
		if ((tostring(job.name)) == tostring(name)) then 
			job_label = job.label
		end
	end
	
	return job_label
end

ESX.RegisterServerCallback('szymczakovv:getJobs', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	local value = {
		first_job = SelectJob(xPlayer.getIdentifier(), 1),
		second_job = SelectJob(xPlayer.getIdentifier(), 2),
	}
	local first_label = CheckJobLabel(value.first_job)
	local second_label = CheckJobLabel(value.second_job)
	local xplayer_label = CheckJobLabel(xPlayer.job.name)
	
	cb(first_label, second_label, xplayer_label)
end)
