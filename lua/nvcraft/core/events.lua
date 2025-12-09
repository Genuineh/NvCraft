-- Simple event bus implementation
local M = {}

local subscribers = {}

--- Publishes an event to all subscribers.
-- @param event (string) The name of the event to publish.
-- @param ... Additional arguments to pass to the subscribers.
function M.publish(event, ...)
	if subscribers[event] then
		for _, callback in ipairs(subscribers[event]) do
			callback(...)
		end
	end
end

--- Subscribes to an event.
-- @param event (string) The name of the event to subscribe to.
-- @param callback (function) The function to call when the event is published.
function M.subscribe(event, callback)
	if not subscribers[event] then
		subscribers[event] = {}
	end
	table.insert(subscribers[event], callback)
end

return M
