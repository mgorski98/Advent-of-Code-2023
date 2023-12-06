using System.IO;
using System;
using System.Linq;
using System.Collections.Generic;
using Internal;

public struct RaceData {
    public ulong Duration { get;set; }
    public ulong Distance { get;set; }

    public RaceData(ulong dur, ulong dist) : this() {
        Duration = dur;
        Distance = dist;
    }
}

public class Program {
    public static RaceData[] ParseInput(string[] lines) {
        var timeLine = lines[0].Replace("Time: ", "");
        var distanceLine = lines[1].Replace("Distance: ", "");
        var timeValues = timeLine.Split(new char[]{' '}, StringSplitOptions.RemoveEmptyEntries).Select(UInt64.Parse).ToArray();
        var distanceValues = distanceLine.Split(new char[]{' '}, StringSplitOptions.RemoveEmptyEntries).Select(UInt64.Parse).ToArray();
        return timeValues.Zip(distanceValues, (f, s) => new Tuple<ulong,ulong>(f,s)).Select(pair => new RaceData(pair.Item1, pair.Item2)).ToArray();
    }

    public static ulong GetPossibleWaysToBeatRace(RaceData data){
        ulong amount = 0ul;
        for (ulong j = 0; j < data.Duration; ++j) {
            ulong speed = j;
            ulong timeLeft = data.Duration - j;
            if (timeLeft * speed > data.Distance)
                amount++;
        }
        return amount;
    }

    public static void Part1(RaceData[] datas) {
        var result = datas.Select(GetPossibleWaysToBeatRace);
        Console.WriteLine("result = {0}", result.Aggregate(1ul, (acc, next) => acc * next));
    }

    public static void Part2(RaceData[] datas) {
        var totalDistance = UInt64.Parse(string.Join("",datas.Select(s => s.Distance.ToString())));
        var totalDuration = UInt64.Parse(string.Join("",datas.Select(s => s.Duration.ToString())));
        var totalData = new RaceData(totalDuration, totalDistance);
        var result = GetPossibleWaysToBeatRace(totalData);
        Console.WriteLine("result = {0}", result);
    }

    public static void Main(string[] args) {
        var lines = File.ReadAllLines("input.txt");
        var raceDatas = ParseInput(lines);
        Part1(raceDatas);
        Part2(raceDatas);
    }
}