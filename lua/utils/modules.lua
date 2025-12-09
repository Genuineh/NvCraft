function keys_create(mode, after, pre, opt)
	return { mode, after, pre, opt }
end

function module_create(plugins, setup, options, keys)
	local mData = {
		keys = keys,
		plugins = plugins,
		setup = setup,
		options = options,
	}
	return mData
end
