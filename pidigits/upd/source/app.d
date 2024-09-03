@safe:
import std;
import std.outbuffer : OutBuffer;
import gmp.z;

alias Z = CopyableMpZ;


void main(string[] args)
{
    auto digits_to_print = args.length > 1 ? args[1].to!int() : 27;

    immutable one = 1.Z;
    immutable two = 2.Z;
    immutable ten = 10.Z;

    int digits_printed = 0;
    auto k = 1.Z;
    auto n1 = 4.Z;
    auto n2 = 3.Z;
    auto d = 1.Z;
    Z u,v,w;

    OutBuffer b = new OutBuffer();
    while(true) {

        u = n1 / d;
        v = n2 / d;
        if (u == v) {
            b.writef("%s",u);
            digits_printed += 1;
            int digits_printed_mod = digits_printed % 10;
            if (digits_printed_mod == 0)
                b.writef("\t%d\n", digits_printed);

            if (digits_printed >= digits_to_print) {
                if (digits_printed_mod > 0) {
                    foreach(_; 0..(10 - digits_printed_mod))
                        b.write(" ");
                    b.writef("\t%d\n", digits_printed);
                }

                write(b.toString());
                return;
            }

            auto to_minus = u * ten * d;
            n1 = n1 * ten - to_minus;
            n2 = n2 * ten - to_minus;
        }
        else {
            auto k2 = k * two;
            u = n1 * (k2 - one);
            v = n2 * two;
            w = n1 * (k - one);
            n1 = u + v;
            u = n2 * (k + two);
            n2 = w + u;
            d = d * (k2 + one);
            k = k + one;
        }
    }
}
