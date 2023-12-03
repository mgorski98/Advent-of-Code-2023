
function readFileLines(path)
    local lines = {}
    local counter = 1
    for line in io.lines(path) do
        lines[counter] = line
        counter = counter+1
    end
    return lines
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function readWholeFile(path) return table.concat(readFileLines(path), "\n") end

function isNum(input) return tonumber(input, 10) ~= nil end

function findAllNums(str)
    return findAll(str,"%d+")
end

function findAll(str, pattern)
    local start, _end = 1, 1
    local i = 1
    local result = {}
    while start ~= nil do
        start, _end = string.find(str, pattern, i)
        if start == nil or _end == nil then break end
        table.insert(result, {str:sub(start,_end), start, _end})
        i = _end + 1
    end
    return result
end

function isSymbol(char)
    return not isNum(char) and char ~= '.'
end

function checkNeighbours(line, start, _end, allLines, lineIndex)
    local rv = false
    local index = lineIndex
    for i = start, _end do
        if lineIndex == 1 then --pierwsza linia, nie sprawdzamy w górę
            if i > 1 then
                if isSymbol(line:sub(i-1,i-1)) then
                    rv = true
                end
                if isSymbol(allLines[index + 1]:sub(i-1,i-1)) then
                    rv = true
                end
            end
            if i < #line then
                if isSymbol(line:sub(i+1,i+1)) then
                    rv = true
                end
                if isSymbol(allLines[index + 1]:sub(i+1,i+1)) then
                    rv = true
                end
            end
            if isSymbol(allLines[index + 1]:sub(i,i)) then
                rv = true
            end
        elseif lineIndex == #allLines then --ostatnia, nie sprawdzamy w dół
            if i > 1 then
                if isSymbol(line:sub(i-1,i-1)) then
                    rv = true
                end
                if isSymbol(allLines[index - 1]:sub(i-1,i-1)) then
                    rv = true
                end
            end
            if i < #line then
                if isSymbol(line:sub(i+1,i+1)) then
                    rv = true
                end
                if isSymbol(allLines[index - 1]:sub(i+1,i+1)) then
                    rv = true
                end
            end
            if isSymbol(allLines[index - 1]:sub(i,i)) then
                rv = true
            end
        else
            if i > 1 then
                if isSymbol(line:sub(i-1,i-1)) then
                    rv = true
                    break
                end
                if isSymbol(allLines[lineIndex-1]:sub(i-1,i-1)) then
                    rv = true
                    break
                end
                if isSymbol(allLines[lineIndex+1]:sub(i-1,i-1)) then
                    rv = true
                    break
                end
            end
            if i < #line then
                if isSymbol(line:sub(i+1,i+1)) then
                    rv = true
                    break
                end
                if isSymbol(allLines[lineIndex+1]:sub(i+1,i+1)) then
                    rv = true
                    break
                end
                if isSymbol(allLines[lineIndex-1]:sub(i+1,i+1)) then
                    rv = true
                    break
                end
            end
            if isSymbol(allLines[lineIndex-1]:sub(i,i)) then
                rv = true
                break
            end
            if isSymbol(allLines[lineIndex+1]:sub(i,i)) then
                rv = true
                break
            end
        end
    end

    return rv
end

function part1(input)
    local sum = 0
    local lines = input
    for index, line in pairs(input) do
       local numsInLine = findAllNums(line)
       for _, value in pairs(numsInLine) do
        local start, _end = value[2], value[3]
        local num = value[1]
        if checkNeighbours(line, start, _end, lines, index) then
            sum = sum + tonumber(num, 10)
        end
       end
    end
    print(sum)
end

function isInRange(value, start, _end)
    for i = start, _end do
        if i == value then return true end
    end
    return false
end

function part2(input)
    local sum = 0
    local lines = input
    for index, line in pairs(input) do
        local allStars = findAll(line, "\*")
        if #allStars > 0 then
            for _, svalue in pairs(allStars) do
                local start, _end = svalue[2], svalue[3]
                local star = svalue[1]
                local adjacentNumbers = {}
                if index > 1 then
                    local topNums = findAllNums(lines[index-1])
                    for _, value in pairs(topNums) do
                        local nstart, nend = value[2],value[3]
                        for i=nstart, nend do
                            if isInRange(nend, start-1, start+1) or isInRange(nstart, start-1, start+1) then
                                table.insert(adjacentNumbers, value[1])
                                break
                            end
                        end
                    end
                end
    
                if index < #lines then
                    local bottomNums = findAllNums(lines[index+1])
                    for _, value in pairs(bottomNums) do
                        local nstart, nend = value[2],value[3]
                        for i=nstart, nend do
                            if isInRange(nend, start-1, start+1) or isInRange(nstart, start-1, start+1) then
                                table.insert(adjacentNumbers, value[1])
                                break
                            end
                        end
                    end
                end
    
                local curLineNums = findAllNums(line)
                for _, value in pairs(curLineNums) do
                    local nstart, nend = value[2],value[3]
                    for i=nstart, nend do
                        if isInRange(nend, start-1, start+1) or isInRange(nstart, start-1, start+1) then
                            table.insert(adjacentNumbers, value[1])
                            break
                        end
                    end
                end
                if #adjacentNumbers == 2 then
                    sum = sum + (tonumber(adjacentNumbers[1], 10) * tonumber(adjacentNumbers[2], 10))
                end
            end
        end
    end
    print(sum)
end

local lines = readFileLines("input.txt")

part1(lines)
part2(lines)
