-- Signal.lua (v2.0)
-- @7kayoh
-- An instance-less signal and listeners implementation in Lua, works with every
-- Lua VM, including Luau.

-- Signal.new() => Signal
-- Creates a new signal object.

-- Signal:Register(listener) => ListenerObject
-- Registers a listener for the signal.

-- Signal:RegisterOnce(callback) => ListenerObject
-- Registers a listener for the signal that will be called only once.

-- Signal:Emit(...)
-- Emits the signal with the given arguments.

-- ListenerObject.Parent
-- The parent signal object.

-- ListenerObject.Index
-- The index of the listener in the parent

-- ListenerObject:Unregister()
-- Unregisters the listener.

local Signal = {}
Signal.__index = Signal

local function createListenerObject(signal, listenerIndex)
    local listenerObject = {}
    listenerObject.Parent = signal
    listenerObject.Index = listenerIndex
    
    function listenerObject:Unregister()
        table.remove(listenerObject.Parent, listenerObject.Index)
    end

    return listenerObject
end

function Signal.new()
    local self = setmetatable({
        ["_listeners"] = {},
        ["_isSignal"] = true,
    }, Signal)

    return self
end

function Signal:Register(listener)
    if self then
        local listenerIndex = #self._listeners+1
        self._listeners[listenerIndex] = listener

        return createListenerObject(self, listenerIndex)
    end
end

function Signal:RegisterOnce(callback)
    if self then
        local listenerIndex = #self._listeners+1
        self._listeners[listenerIndex] = function(...)
            table.remove(self._listeners, listenerIndex)
            callback(...)
        end

        return createListenerObject(self, listenerIndex)
    end
end

function Signal:Emit(...)
    if self then
        for _, listener in ipairs(self._listeners) do
            coroutine.wrap(listener)(...)
        end
    end
end

return Signal