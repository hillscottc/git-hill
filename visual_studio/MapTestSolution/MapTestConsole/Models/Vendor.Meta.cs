using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    public partial class Vendor
    {

        public static int GetIdByName(string name)
        {
            using (ResultModelContainer dbTest = new ResultModelContainer())
            {
                int id = (from v in dbTest.Vendors
                          where v.Name.Equals(name)
                          select v.Id).SingleOrDefault();
                return id;
            }
        }

    }
}
