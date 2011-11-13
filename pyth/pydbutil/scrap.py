#! /usr/bin/python

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



