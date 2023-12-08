import java.nio.file.Files
import java.nio.file.Paths
import java.util.concurrent.atomic.AtomicInteger

fun parse(input: List<String>): HashMap<String, Pair<String, String>> {
    val coordsMap = HashMap<String, Pair<String, String>>()
    input.subList(1, input.size).forEach { s -> run {
        val parts = s.split(" = ")
        val leftRightDirs = parts[1].replace("(", "").replace(")", "").split(", ")
        coordsMap[parts[0]] = Pair(leftRightDirs[0].trim(), leftRightDirs[1].trim())
    } }
    return coordsMap
}

fun part1(input: List<String>) {
    val coordsMap = parse(input)
    val directionString = input[0]
    var currentNode = "AAA"
    var steps = 0
    while (currentNode != "ZZZ") {
        directionString.chars().forEach { c -> run {
            val tup = coordsMap[currentNode]!!
            currentNode = if (c.toChar() == 'L') tup.first else tup.second
            steps++
        } }
    }
    println("result = $steps")
}

fun part2(input: List<String>) {
    val coordsMap = parse(input)
    val startingNodes = coordsMap.keys.filter { it.endsWith("A") }
    val resultMap = HashMap<String, Long>()

    for (node in startingNodes) {
        var currentNode = node
        var currentSteps = 0L

        while (!currentNode.endsWith("Z")) {
            input[0].chars().forEach { c -> run {
                val tup = coordsMap[currentNode]!!
                currentNode = if (c.toChar() == 'L') tup.first else tup.second
                currentSteps++
            } }
        }

        resultMap[currentNode] = currentSteps
    }

    val result = lcm_rec(resultMap.values.toTypedArray())
    println("result = $result")
}

fun lcm(a: Long, b: Long): Long {
    return a * b / gcd(a, b)
}

fun lcm_rec(outputs: Array<Long>): Long {
    return if (outputs.size ==2) lcm(outputs[0],outputs[1]) else lcm(outputs[0], lcm_rec(outputs.drop(1).toTypedArray()))
}

fun gcd(a: Long, b:Long): Long {
    var _a = a
    var _b = b
    while (_b != 0L) {
        val temp = _b
        _b = _a % _b
        _a = temp
    }
    return _a
}

fun main(args: Array<String>) {
    val lines = Files.readAllLines(Paths.get("input.txt")).filter { it.isNotEmpty() }.toList()
    part1(lines)
    part2(lines)
}
