from time import monotonic

@value
struct BitSet:
    """A memory-efficient bit set implementation."""

    var data: List[UInt8]
    var size: Int  # number of bits

    fn __init__(mut self, size: Int):
        """Initialize a BitSet with given number of bits."""
        # Calculate bytes needed (1 byte = 8 bits)
        bytes = (size + 7) // 8
        self.data = List[UInt8](capacity=bytes)
        self.size = size
        # Initialize all bits to 1 (true)
        for i in range(bytes):
            self.data[i] = 0xFF

    @always_inline
    fn set(mut self, index: Int, value: Bool):
        """Set bit at index to value (true=1, false=0)."""
        debug_assert(index < self.size, "BitSet index out of bounds")
        byte_idx = index // 8
        bit_idx = index % 8
        mask = UInt8(1) << bit_idx
        if value:
            self.data[byte_idx] |= mask
        else:
            self.data[byte_idx] &= ~mask

    @always_inline
    fn get(self, index: Int) -> Bool:
        """Get bit value at index."""
        debug_assert(index < self.size, "BitSet index out of bounds")
        byte_idx = index // 8
        bit_idx = index % 8
        mask = UInt8(1) << bit_idx
        return (self.data[byte_idx] & mask) != 0

    fn __getitem__(self, index: Int) -> Bool:
        """Get bit value at index using bracket notation."""
        return self.get(index)

    fn __setitem__(mut self, index: Int, value: Bool):
        """Set bit value at index using bracket notation."""
        self.set(index, value)

fn sieve_of_eratosthenes(num: Int) -> None:
    """Find prime numbers up to num using BitSet."""
    var prime = BitSet(num + 1)
    prime[0] = False
    prime[1] = False

    var p = 2
    while p * p <= num:
        if prime[p]:
            # Mark multiples as non-prime
            var i = p * p
            while i <= num:
                prime[i] = False
                i += p
        p += 1

fn main():
    start = monotonic()
    limit = 1000000000
    sieve_of_eratosthenes(limit)
    end = monotonic()
    print("Time taken in secs:", (end - start) / 1000 / 1000 / 1000)
