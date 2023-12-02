//@ts-ignore
import * as fs from 'fs';

function readLines(path: string): string[] {
    var fileContents = fs.readFileSync(path, 'utf-8');
    return fileContents.split('\n').map(l => l.trim()).filter(l => l !== '');
}

const LIMITS: {[key: string]: number} = {
    'red': 12,
    'green': 13,
    'blue': 14,
};

function part1(){
    const fileLines = readLines("input.txt");
    const result = new Set<number>();
    fileLines.forEach(line => {
        var [gameData, cubeData] = line.split(":");
        var id = parseInt(gameData.split(" ")[1]);
        cubeData = cubeData.trim().replaceAll(';', ',');
        const parts = cubeData.split(", ")
        const valid = parts.every(part => {
            const [count, color]=part.trim().split(" ");
            const intCount = parseInt(count);
            return intCount <= LIMITS[color];
        });
        if (valid)
            result.add(id);
    });
    console.log(Array.from(result).reduce((sum, curr) => sum + curr, 0));
}

function part2() {
    const fileLines = readLines("input.txt");
    var powerSum = 0;
    fileLines.forEach(line => {
        const minValuesNeededMap: {[key:string]: number} = {
            'red': -1,
            'green':-1,
            'blue': -1
        };
        var [_, cubeData] = line.split(":");
        cubeData = cubeData.replaceAll(';', ',').trim();
        const data = cubeData.split(" ");
        for (var i = 0; i < data.length; i += 2) {
            const count = parseInt(data[i]);
            const color = data[i+1].replaceAll(',', '');
            const current = minValuesNeededMap[color];
            if (count > current){
                minValuesNeededMap[color] = count;
            }
        }
        powerSum += minValuesNeededMap['red'] * minValuesNeededMap['green'] * minValuesNeededMap['blue'];
    });
    console.log(powerSum);
}

// part1();
part2();