import std.stdio, std.algorithm, std.string;

void main()
{
    string[] buf;
    foreach(_; 0..1000)
    {
        auto s = readln.strip();
        buf ~= s;
    }
    buf.each!writeln;
}