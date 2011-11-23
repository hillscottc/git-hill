#! /usr/bin/python





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





#this was part of configmgr. but i dont need xml here.

def handle_xml(self, env=None, write=None, *xml_file_list):
    """Find and change connectionStrings node of xmlfile.
    Tests for this are function are in in 'test_ConfigMgr.txt'
    Run ./ConfigMgr.py -v         
    """

    if env:
        self.env = env
    
    self.write = write

    if len(xml_file_list) > 0:
        self.filelist = xml_file_list

    tot_match_count = 0
    match_msg = ''
    for xmlfilename in self.filelist:

        print "File:", os.path.abspath(xmlfilename)
        matchcount = 0
        tree = ElementTree()
        root = tree.parse(xmlfilename)
        for con_str_node in root.findall('connectionStrings'):
            for add_node in con_str_node.findall('add'):
                old_conn = add_node.attrib['connectionString']
                # change the con node here
                add_node.attrib['connectionString'] = self.change_conn(old_conn, self.env)
                matchcount = matchcount + 1
            tot_match_count = tot_match_count + matchcount
            match_msg = match_msg + str(matchcount) + ' matches in file ' + xmlfilename + os.linesep

        if self.write:
            newfilename = self.get_output_filename(xmlfilename)
            tree.write(newfilename)
            print 'Wrote', newfilename

    print
    print match_msg
    if len(self.filelist) > 1:
        print str(tot_match_count) + ' TOTAL changes.'



