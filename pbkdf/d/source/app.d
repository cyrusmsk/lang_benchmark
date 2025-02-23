import std.stdio;
import std.base64;
import kdf.pbkdf2;
import std.datetime;
import std.digest.sha;
import std.string : representation;
import std.datetime.stopwatch : AutoStart, StopWatch;


void main()
{
  auto sw = StopWatch(AutoStart.no);
  immutable password = "testc2usertestc2user", salt = "o328TeiMlyvfohWn8WuRwA";
  sw.start();
  auto dk256 = Base64.encode(pbkdf2!SHA256(password.representation, salt.representation, 600_000, 32));
  auto elapsed = sw.peek();
  sw.stop();
  writefln("Hash: --> %s\nDuration: %s", dk256, elapsed);
}
