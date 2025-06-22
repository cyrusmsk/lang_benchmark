import sys
import asyncio


async def main():
    n = 100 if len(sys.argv) < 2 else int(sys.argv[1])
    sum_prime = 0
    ch = generate()
    for i in range(0, n):
        prime = await ch.__anext__()
        print(prime)
        sum_prime = sum_prime + prime
        ch = filter(ch, prime)
    print(sum_prime)


async def generate():
    i = 2
    while True:
        yield i
        i += 1


async def filter(ch, prime):
    async for i in ch:
        if i % prime != 0:
            yield i

if __name__ == '__main__':
    sys.setrecursionlimit(10000)
    asyncio.run(main())
