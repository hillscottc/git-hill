

#    
#    
#    # read all lines of file into var
#    with open(filename, 'r') as infile:
#        lines = infile.readlines()
#    
#    mcList = []
#    linenum = 0
#    outlines = ''
#    
#    # check lines
#    for line in lines:
#        linenum = linenum +1
#        
#        mc = self.parse_line(line, env, app)
#        
#        if mc:
#            mc.linenum = linenum
#            mcList.append(mc)  
#            if write:
#                if mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ', 'FTP') :
#                    line = re.sub(mc.before, mc.after, line, re.IGNORECASE)
#                elif mc.mtype in  ('LOG_A', 'LOG_B') :
#                    line = re.sub(re.escape(mc.before), mc.after, line, re.IGNORECASE)
#                elif mc.mtype is  'DB' :
#                    #line = re.sub(re.escape(m.group(1)), mc.after.boxname, line, re.IGNORECASE)
#                    line = re.sub(re.escape(mc.before_raw), mc.after.boxname, line, re.IGNORECASE)
#                else :
#                    raise 'why it not one of em?'
#        
#        outlines = outlines + line
# 
# ms.matches[filename] = sorted(mcList, key = lambda x: x.linenum)
# 
# if write:
#     outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR, 
#                                                 ConfigMgr.OUTPUT_DIR, filename)
#     with open(outfilename, 'w') as outfile:
#         outfile.write(outlines)