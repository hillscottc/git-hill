
# net use x: \\% %\d$\Oracle\
# \\USHPEWVAPP354\d$\Oracle\InstantClient\TNS

# def use_box(box):
# 	net use x: /delete
# 	net use x: \\% %\d$\

import sys, os


path = sys.argv[1]

if os.path.isdir( os.path.join('\\\\', path, 'd$', 'Oracle', 'InstantClient', 'TNS')):
	print 'is a dir'
else:
	print 'not a dir'


path = os.path.join('\\\\', path, 'd$', 'Oracle', 'InstantClient', 'TNS', 'tnsnames.ora')

#print 'path is ', path


if os.path.exists(path):
    print path, '.........'
    with open(path, 'r') as infile:
        lines = infile.readlines()
    for i, line in enumerate(lines):
        print line
        if i > maxline: break
else:
	print path, "doesn't exist."



# def check(path, maxline=10):
#     path = os.path.join('x:\\', 'Oracle', 'InstantClient', 'TNS', 'tnsnames.ora')
#     if os.path.exists(path):
#         print path, '.........'
#         with open(path, 'r') as infile:
#             lines = infile.readlines()
#         for i, line in enumerate(lines):
#             print line
#             if i > maxline: break
	
# boxes = ("USHPEWVAPP103", "USHPEWVAPP251", "USHPEWVAPP354", 
# 		 "USHPEWVAPP085", "USHPEWVAPP086", "USHPEWVAPP091",
# 		 "USHPEWVAPP061", "USHPEWVAPP023", "USHPEWVAPP355",
# 		 "USHPEWVAPP204")

# for box in boxes:
#     path = os.path.join('x:\\', 'Oracle', 'InstantClient', 'TNS', 'tnsnames.ora')
#     if os.path.exists(path):
#         check(path)
# else:
#     print path, "doesn't exist."

