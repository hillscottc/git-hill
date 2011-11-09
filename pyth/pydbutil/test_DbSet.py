

Run ./DbSet.py -v  to run these tests.

>>> dbset = DbSet('input/DbSet.data.csv')

Have a training RDxETL?
>>> print dbset.get_profile_by_attribs(dict(env='training', dbname='RDxETL'))
None

Have a prod RDxETL?
>>> print dbset.get_profile_by_attribs(dict(env='prod', dbname='RDxETL'))
MP RDxETL prod usfshwssql077 sourcepath targpath

Have a prod box on usfshwssql084?
>>> print dbset.get_profile_by_attribs(dict(env='prod', boxname='usfshwssql084'))
MP RDxReport prod usfshwssql084 sourcepath targpath

Have a RDxETL on usfshwssql104?
>>> print dbset.get_profile_by_attribs(dict(dbname='RDxETL', boxname='usfshwssql104'))
MP RDxETL dev usfshwssql104 sourcepath targpath




