#! /usr/bin/python

#    def set_cvsfile(self, value):
#        dr = csv.DictReader(open(value, 'rb'), delimiter=',', quotechar="'")
#        dbprofiles = [DbProfile(**row) for row in dr]    
#        self.DB = [db for db in dbprofiles]
#        self._cvsfile = value
#    def get_cvsfile(self):
#        return self._cvsfile
#    cvsfile = property(get_cvsfile, set_cvsfile)



  @staticmethod
    def get_filelist(path=None, *apps):
        """Gets config files for app name in given path. 
        Matches files with {app}*.exe in the file for the given path.

        Usage:  
        >>> print ConfigMgr.get_filelist('input/', 'MP')
        ['input/ETL/MP/log4net.config', 'input/ETL/MP/UMG.RDx.ETL.MP.exe.config', 'input/ETL/MP/UMG.RDx.ETL.MP.Extract.dll.config', 'input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config']
        
        >>> print ConfigMgr.get_filelist('input/', 'MP', 'CARL')
        ['input/ETL/MP/log4net.config', 'input/ETL/MP/UMG.RDx.ETL.MP.exe.config', 'input/ETL/MP/UMG.RDx.ETL.MP.Extract.dll.config', 'input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config', 'input/ETL/CARL/Copy of UMG.RDx.ETL.CARL.dll.config', 'input/ETL/CARL/log4net.config', 'input/ETL/CARL/UMG.RDx.ETL.CARL.dll.config', 'input/ETL/CARL/UMG.RDx.ETL.FileService.exe.config', 'input/ETL/Common/UMG.RDx.ETL.CARL.dll.config']

        How many for these?
        >>> print len(ConfigMgr.get_filelist('input/', 'MP', 'CARL', 'R2'))
        12
        
        
        #>>> print ConfigMgr.get_filelist('input/ETL/MP/UMG.RDx.ETL.MP.exe.config','ABC')
        #Traceback (most recent call last):
        #    ...
        #Exception: input/UMG.RDx.ETL.MP.exe.config does not match with app ABC
        """
        if not apps: raise Exception('apps required for get_filelist.')
        if not path: raise Exception('path is required for get_filelist.')
        filelist = []
        
        if os.path.isfile(path) :
            filelist.append(path)
#            if re.search(app + '.+exe', path):
#                filelist.append(path)
#            else:
#                raise Exception, '{} does not match with app {}'.format(path, app)
        elif os.path.isdir(path) :
            for app in apps:
                for root, dirs, files in os.walk(path):
                    for name in dirs:
                        for filename in glob.glob(os.path.join(root, name, "*.config")) :
                            #if re.search(app + '.+exe', filename): 
                            if re.search(app, filename): 
                                filelist.append(filename)
        else:
            msg = path  + ' does not exist.'
            raise Exception(msg)
        return filelist


        # m = None
        # # which of the co's does this line match?
        # for co in self.CONFIG_OBJS:
        #     m = re.search(co.regex, line, re.IGNORECASE)
        #     if m:
        #         break
        # 
        # if m:
        # 
        # 
        #     if co.cotype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
        #         
        #         
        #         print 'FOUND', co.cotype 
        # 
        #         mc = MatchedConfig(mtype=co.cotype, before=m.group(1),
        #                            linenum=linenum, after=co.changeval)
        #                                             
        #         print mc
        # 
        #         maList.append(mc)
        #         if write:
        #             line = re.sub(mc.before, mc.after, line, re.IGNORECASE)
        # 
        # 
        #     elif co.cotype in ('LOG_A', 'LOG_B') :
        # 
        #         mc = MatchedConfig(mtype=co.cotype, before=m.group(1),
        #                            linenum=linenum, after=self.get_logname(app))
        # 
        #         maList.append(mc)
        #         try:
        #             if write:
        #                 line = re.sub(re.escape(mc.before),
        #                               mc.after, line, re.IGNORECASE)
        #         except:
        #             print '*** File {0} , line {1} not updated.'.format(
        #                                    filename, line)
        #             print '*** Failed to change {0} to {1}'.format(
        #                                    mc.before, mc.after)
        # 
        #     elif co.cotype is 'FTP':
        # 
        #         mc = MatchedConfig(mtype=co.cotype, before=m.group(2),
        #                            linenum=linenum, after=self.FTP_ROOT,
        #                            newname=m.group(1))
        # 
        #         maList.append(mc)
        #         if write:
        #             line = re.sub(mc.before, mc.after, line, re.IGNORECASE)
        # 
        #     elif co.cotype is 'DB':
        #         mc = self.parse_line_db(m, line, linenum, env, app)
        # 
        #         maList.append(mc)
        # 
        #         if write :
        #             line = re.sub(re.escape(m.group(1)),
        #                           mc.after.boxname, line, re.IGNORECASE)


