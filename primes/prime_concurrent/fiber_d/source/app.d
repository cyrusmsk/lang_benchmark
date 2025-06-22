import core.stdc.stdlib: exit;
import core.stdc.stdio: printf;
import core.thread;
import std.concurrency;
import std.conv;

__gshared Tid mainTid;
__gshared bool terminated = false;

const int mailBoxSize = 1;

void main(string[] args) {
    auto n = args.length > 1 ? args[1].to!int() : 10;

    long sum_prime = 0;
    scheduler = new FiberScheduler;
    scheduler.start({
        mainTid = thisTid();
        setMaxMailboxSize(mainTid, n, OnCrowding.throwException);
        auto filterTid = spawnLinked(&filter, n);
        setMaxMailboxSize(filterTid, mailBoxSize, OnCrowding.block);
        auto generatorTid = spawnLinked(&generate, filterTid);
        for(auto i=0;i<n;i++){
            auto prime = receiveOnly!int;
            sum_prime += prime;
        }
        printf("%d\n",sum_prime);
        terminated = true;
        exit(0);
    });    
}

void generate(Tid tid) {
    for (auto i=2;!terminated;i++) {
        tid.send(i);
    }
}

void filter(int nLeft) {
    auto prime = receiveOnly!int;
    mainTid.send(prime);
    if (nLeft > 0) {        
        filterInner(prime, nLeft);
    }
}

void filterInner(int prime, int nLeft) {
    auto nextTid = spawnLinked(&filter, nLeft-1);
    setMaxMailboxSize(nextTid, mailBoxSize, OnCrowding.block);
    while(!terminated){
        auto d = receiveOnly!int;
        if (d % prime != 0) {
            nextTid.send(d);
        }
    }
}
