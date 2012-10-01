using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;

namespace MapTestConsole.Models
{
    public partial class Vendor
    {
        private static ILog log = LogManager.GetLogger(typeof(Vendor));

        public static Vendor GetByName(string name)
        {
            using (ResultModelContainer dbTest = new ResultModelContainer())
            {
                Vendor v = null;

                try
                {
                    v = (dbTest.Vendors.Where(e => e.Name.Equals(name)).Single());
                }
                catch (Exception)
                {
                    log.ErrorFormat("Vendor not found for '{0}'", name);
                    throw;
                }
                return v;
            }
        }

    }
}
