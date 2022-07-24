import core.stdc.stdio : printf, puts;
immutable maxLine = 60;
immutable im = 139_968;
immutable ia = 3_877;
immutable ic = 29_573;

uint seed = 42;

int parseInt(string s) nothrow @safe @nogc
{
   bool isNeg = false;
   assert(s.length > 0);
   if(s[0] == '-') {isNeg = true; s = s[1 .. $];}
   int result = 0;
   foreach(c; s) {
      assert(c >= '0' && c <= '9');
      result = result * 10 + (c - '0');
   }
   return result;
}

static struct AminoAcid {
    char l;
    double p;
}

double nextRandom(double max) {
    seed = (seed * ia + ic) % im;
    return max * seed/im;
}

void repeatAndWrap (immutable char[] seq, size_t count) {
    uint len = cast(uint) seq.length;
    char[] paddedSeq = new char[len + maxLine];
    foreach (i, ref e; paddedSeq)
        e = seq[i % len];

    size_t off, idx;
    while (idx < count) {
        immutable rem = count - idx;
        immutable size_t lineLength = maxLine < rem ? maxLine : rem;

        // speed up the writeln with lockWriter
        puts(paddedSeq[off .. off + lineLength].ptr);
        printf("\n");
        
        off += lineLength;
        if (off > len)
            off -= len;
        idx += lineLength;
    }
}

void generateAndWrap (immutable AminoAcid[] nucleotides, size_t count) {
    double cumProb = 0.0;
    double[] cumProbTotal = new double[](nucleotides.length);
    foreach(i, e; nucleotides) {
        cumProb += e.p;
        cumProbTotal[i] = cumProb * im;
    }

    char[] line = new char[](maxLine+1);
    line[maxLine] = '\n';
    size_t idx;
    while (idx < count) {
        immutable rem = count - idx;
        immutable size_t lineLength = maxLine < rem ? maxLine : rem;
        foreach (ref col; line[0 .. lineLength]) {
            immutable r = nextRandom(im);
            size_t c;
            foreach (n; cumProbTotal)
                if (n <= r)
                    c++;
            col = nucleotides[c].l;
        }
        line[lineLength] = '\n';
        puts(line[0 .. lineLength + 1].ptr);

        idx += lineLength;
    }
}

void main(string[] args) {
    immutable uint n = args.length > 1 ? parseInt(args[1]) : 100;
    
    static immutable char[72*3 + 71] homoSapiensAlu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
    printf(">ONE Homo sapiens alu\n");
    repeatAndWrap(homoSapiensAlu, 2 * n);

    static immutable AminoAcid[15] iubNucleotideInfo = [
        { l:'a', p: 0.27 },
        { l:'c', p: 0.12 },
        { l:'g', p: 0.12 },
        { l:'t', p: 0.27 },
        { l:'B', p: 0.02 },
        { l:'D', p: 0.02 },
        { l:'H', p: 0.02 },
        { l:'K', p: 0.02 },
        { l:'M', p: 0.02 },
        { l:'N', p: 0.02 },
        { l:'R', p: 0.02 },
        { l:'S', p: 0.02 },
        { l:'V', p: 0.02 },
        { l:'W', p: 0.02 },
        { l:'Y', p: 0.02 },
    ];
    printf(">TWO IUB ambiguity codes\n");
    generateAndWrap(iubNucleotideInfo, 3 * n);

    static immutable AminoAcid[4] homoSapienNucleotideInfo = [
        { l:'a', p: 0.3029549426680 },
        { l:'c', p: 0.1979883004921 },
        { l:'g', p: 0.1975473066391 },
        { l:'t', p: 0.3015094502008 },
    ];
    printf(">THREE Homo sapiens frequency\n");
    generateAndWrap(homoSapienNucleotideInfo, 5 * n);
}
