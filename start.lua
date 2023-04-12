#!/usr/bin/env lua
print("Astaroth benchmarking script")
math.randomseed(os.time())

local astarothBasePath = "/home/username/astaroth_base/astaroth/"
local prefix = "amd"

local function GetRandomString(length)
    return (length > 0) and (string.char(math.random(97, 122)) .. GetRandomString(length - 1)) or ""
end

local function RunAstarothCopy(threadsPerBlock, implementation)
    local targetPath = "/home/username/temp_astaroth/" .. GetRandomString(24)
    local resultsPath = string.format("/home/username/bench_results/%s_%d_%d", prefix, threadsPerBlock, implementation)
    os.execute("mkdir -p " .. resultsPath)

    print(string.format("Copying new Astaroth to %s (results: %s)", targetPath, resultsPath))
    os.execute("mkdir -p " .. targetPath)
    os.execute(string.format("rsync -a %s %s", astarothBasePath, targetPath))

    local buildPath = targetPath .. "/build"

    os.execute(string.format([[mkdir "%s" && cd "%s" && cmake -DUSE_HIP=ON -DBUILD_SHARED_LIBS=ON -DMAX_THREADS_PER_BLOCK=%d -DIMPLEMENTATION=%d .. > /dev/null && make -j > /dev/null]],
        buildPath, buildPath, threadsPerBlock, implementation))

    print("Now running tests")
    os.execute(string.format([[cd "%s" && ./benchmark-device 192 192 192 > %s/%s 2>&1]], buildPath, resultsPath, GetRandomString(24)))

    print("Cleaning up")
    os.execute(string.format([[cd && rm -rf %s]], targetPath))
end

for j = 1, 2 do
    for i = 0, 1536, 32 do
        RunAstarothCopy(i, j)
    end
end
