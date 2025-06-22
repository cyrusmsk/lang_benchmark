import core.thread;
import std;

class Generator(T) : Fiber {
	private T value;

	this(void delegate() dg) {
		super(dg);
	}

	static void yield(T value) {
		(cast(Generator!T) Fiber.getThis()).value = value;
		Fiber.yield();
	}

	T getNext() {
		call();
		return value;
	}

	int opApply(scope int delegate(T) dg) {
		int result = 0;

		while (state != State.TERM) {
			result = dg(getNext());
			if (result)
				break;
		}
		return result;
	}
}

auto generate() {
	return new Generator!long({
		long i = 2;
		while (true) {
			Generator!long.yield(i);
			i += 1;
		}
	});
}

auto filter(Generator!long ch, long prime) {
	return new Generator!long({
		foreach (i; ch)
			if (i % prime != 0)
				Generator!long.yield(i);
	});
}

void main(string[] args) {
    long n = args.length > 1 ? args[1].to!long: 10;

    long sum_prime = 0;
	Generator!long ch = generate();
	foreach (i; 0 .. n) {
		long prime = ch.getNext();
        sum_prime += prime;
		ch = filter(ch, prime);
	}
    writeln(sum_prime);
}
