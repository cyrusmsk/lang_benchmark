import std;

struct Node
{
    Node* left;
    Node* right;

    int check() {
        if ((this.left is null) || (this.right is null))
            return 1;
        return this.left.check + this.right.check + 1;
    }
}
    
Node* createNode(int n) {    
        if (n == 0)
            return new Node(null, null);
        return new Node(createNode(n - 1), createNode(n - 1));
    }

void main(string[] argv)
{
    int min_depth = 4;
    int max_depth = max(min_depth + 2, to!int(argv[1]));

    int stretch_depth = max_depth + 1;
    Node* stretch_tree = createNode(stretch_depth);

    writeln("stretch tree of depth ", stretch_depth, "\t check: ", stretch_tree.check);
    stretch_tree = null;

    Node* long_lived_tree = createNode(max_depth);
    int mmd = max_depth + min_depth;

    for (int depth = min_depth; depth < stretch_depth; depth += 2) {
        auto iterations = 2 ^^ (mmd - depth);

        int check_var = 0;
        for (int i = 1; i <= iterations; i++) {
            Node* temp_tree = createNode(depth);
            check_var += temp_tree.check;
        }

        writeln(iterations, "\t trees of depth ", depth, "\t check: ", check_var);
    }

    writeln("ling lived tree of depth ", max_depth, "\t check: ", long_lived_tree.check);
}
