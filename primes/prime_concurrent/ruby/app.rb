def get_n()
    n = 100
    if ARGV.size > 0
        n= Integer(ARGV[0])
    end
    n
end

def generate()
    return Fiber.new do
        i = 2
        while true do
            Fiber.yield i
            i += 1
        end
    end
end

def filter(fiber_in, prime)
    return Fiber.new do 
        while true do
            i = fiber_in.resume
            if i % prime != 0
                Fiber.yield i
            end
        end
    end
end

n = get_n()
ch = generate
sum_prime = 0
(0...n).each do
    prime = ch.resume
    sum_prime = sum_prime + prime
    ch = filter(ch, prime)
end
puts sum_prime
