import std.stdio, std.string;

void main()
{
    foreach(_; 0..1000)
    {
        auto s = readln.strip();
        s.writeln;
    }
}