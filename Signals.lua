--@2kayoh
local Signals = {}
local _signalsHolder = {}
Signals.__index = Signals

function Signals.new(Name)
	local signalObject = setmetatable({
		["Name"] = Name,
		["_IsSignal"] = true,
		["_Slots"] = {},
	}, Signals)
	signalObject.GetSignal = nil
	table.insert(_signalsHolder, signalObject)
	return signalObject
end

function Signals:GetSignal(Name)
	for _, signal in ipairs(_signalsHolder) do
		if signal.Name == Name then
			return signal
		end
	end
end

function Signals:Register(Slot)
	if not self._IsSignal then
		return
	end

	table.insert(self._Slots, Slot)
end

function Signals:Emit(...)
	local arguments = {...}
	if not self._IsSignal then
		return
	end

	for _, slot in ipairs(self._Slots) do
		coroutine.wrap(function()
			pcall(slot, table.unpack(arguments))
		end)()
	end
end

function Signals:Destroy()
	if not self._IsSignal then
		return
	end

	self._Slots = nil
	self = nil
end

return Signals