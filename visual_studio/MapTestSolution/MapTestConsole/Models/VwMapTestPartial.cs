using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    using System;
    using System.Collections.Generic;

    public partial class vwMapTest
    {
        /// <summary>
        /// Geneva's method to build location string.
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public string GetLocationString(params string[] args)
        {

            string[] locBits = new string[] { this.City, this.Region, this.PostalCode };

            System.Globalization.CultureInfo cul = System.Globalization.CultureInfo.CurrentCulture;
            string strUnknown = "UnknownLocation";

            string strLocation = string.Empty;
            if (locBits != null)
            {
                foreach (string s in locBits)
                    if (s != null && s.ToLower() != "none" && s != string.Empty)
                        strLocation += (strLocation == "") ? s : ", " + s;
            }
            return (strLocation == "") ? strUnknown : strLocation;
        }

    }
}
