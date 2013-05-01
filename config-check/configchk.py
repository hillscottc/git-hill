import telnetlib
from models import Site

SITES = dict(
    t1=Site('t1', "Starwars", "towel.blinkenlights.nl"),
    t2=Site('t2', "Excuses", "towel.blinkenlights.nl 666"),
    t3=Site('t3', "Telehack", "telehack.com"),
)


def do_login(host, user=None, password=None):
    tn = telnetlib.Telnet(host)
    tn.read_until("login: ")
    tn.write(user + "\n")
    if password:
        tn.read_until("Password: ")
        tn.write(password + "\n")
    tn.write("ls\n")
    tn.write("exit\n")
    print tn.read_all()


def do_query(host):
    tn = telnetlib.Telnet(host)
    print tn.read_until("fish", 7)


if __name__ == '__main__':
    do_query(SITES['t1'].host)
