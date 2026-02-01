Coroutines = {}

function Wait(seconds)
    local start = os.clock() -- Track start time
    while os.clock() - start < seconds do
        print("waiting")
        coroutine.yield() -- Pause and yield control
    end
end

function StartCoroutine(func, ...)
    local co = coroutine.create(func)
    coroutine.resume(co, arg)
    table.insert(Coroutines, {co, arg})
    return co
end

function UpdateCoroutines()
	for i = #Coroutines, 1, -1 do
        local arguments = Coroutines[i];
        local co = Coroutines[i][1]
        local success, err = coroutine.resume(co, arguments[2],arguments[3])
        if not success then
            print("Coroutine error:", err)
            --table.remove(Coroutines, i)
        elseif coroutine.status(co) == "dead" then
            -- Remove coroutine once it finishes
            table.remove(Coroutines, i)
        end
    end    
end