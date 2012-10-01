using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    public partial class Vendor
    {
        public static Vendor GetByName(string name)
        {
            using (ResultModelContainer dbTest = new ResultModelContainer())
            {
                Vendor v = null;

                v = (dbTest.Vendors.Where(e => e.Name.Equals(name)).SingleOrDefault());

                return v;
            }
        }



     

    }
}
