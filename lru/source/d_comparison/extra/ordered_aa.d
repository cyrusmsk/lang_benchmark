/**
 * Ordered Associative Array modeled from Python's OrderedDict.
 *
 * Subtypes built-in associative arrays.
 *
 * It works by using an array to keep the key order in addition to a regular
 * associative array.
 */
struct OrderedAA(T) if (isAssociativeArray!T) {
    import std.algorithm;
    import std.typecons;

    alias KeyType!T   keyT;
    alias ValueType!T valueT;

    private keyT[] _order;
    private T      _aa;

    alias _aa this;

    /**
     * Associative Array based Constructor
     */
    this(T base) {
        _order.reserve(base.length);

        foreach (key, value ; base) {
            _order   ~= key;
            _aa[key]  = value;
        }
    }

    /**
     * Ordered Associative Array based Constructor
     */
    this(OrderedAA!T base) {
        _order.reserve(base.length);

        foreach (key, value ; base.byKeyValue) {
            _order   ~= key;
            _aa[key]  = value;
        }
    }

    /**
     * Remove all contents from the container.
     */
    void clear() {
        _aa    = null;
        _order = null;
    }

    /**
     * Returns a range of keys in order
     */
    auto byKey() {
        return _order.dup;
    }

    /**
     * Returns a range of values in order
     */
    auto byValue() {
        return _order.map!(x => _aa[x]);
    }

    /**
     * Returns a range of tuples (key, value) in order
     */
    auto byKeyValue() {
        return _order.map!(x => tuple(x, _aa[x]));
    }

    auto ref opIndex() {
        return _order[];
    }

    auto ref opIndex(const keyT key) {
        return _aa[key];
    }

    void opIndexAssign(const valueT value, const keyT key) {
        if (key !in _aa)
            _order ~= key;
        _aa[key] = value;
    }

    /**
     * Remove an element in place given its key
     * Returns false if the element wasn't in the array, true otherwise
     */
    bool remove(const keyT key) {
        auto index = _order.countUntil(key);

        if (index == -1)
            return false;

        _order = std.algorithm.remove(_order, index);
        _aa.remove(key);
        return true;
    }
 }