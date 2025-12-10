-- Simple event bus implementation
-- Event bus with history, priorities, and async execution.
local M = {}

local subscribers = {}
local history = {}

--- Publishes an event to all subscribers.
local function publish(event, async, ...)
	table.insert(history, {
		event = event,
		timestamp = os.time(),
		args = { ... },
		async = async,
	})

	if not subscribers[event] then
		return
	end

	-- Create a copy and sort subscribers by priority
	local sorted_subscribers = vim.deepcopy(subscribers[event])
	table.sort(sorted_subscribers, function(a, b)
		return a.priority < b.priority
	end)

	local args = { ... }
	for _, subscriber in ipairs(sorted_subscribers) do
		if async then
			vim.schedule(function()
				subscriber.callback(unpack(args))
			end)
		else
			subscriber.callback(unpack(args))
		end
	end
end

--- Publishes an event asynchronously.
-- @param event (string) The name of the event to publish.
-- @param ... Additional arguments to pass to the subscribers.
function M.publish(event, ...)
	publish(event, true, ...)
end

--- Publishes an event synchronously.
-- @param event (string) The name of the event to publish.
-- @param ... Additional arguments to pass to the subscribers.
function M.sync(event, ...)
	publish(event, false, ...)
end

--- Subscribes to an event.
-- @param event (string) The name of the event to subscribe to.
-- @param callback (function) The function to call when the event is published.
-- @param priority (number, optional) The priority of the subscriber (lower is higher). Defaults to 100.
function M.subscribe(event, callback, priority)
	if not subscribers[event] then
		subscribers[event] = {}
	end
	table.insert(subscribers[event], {
		callback = callback,
		priority = priority or 100,
	})
end

--- Returns the event history.
-- @return (table) A list of all published events.
function M.get_history()
	return history
end

return M
