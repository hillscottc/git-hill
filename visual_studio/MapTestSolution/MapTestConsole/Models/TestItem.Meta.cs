using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    public partial class TestItem : ITestItem
    {

        /// <summary>
        /// Geneva's method to build location string.
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public string GetLocationString(params string[] args)
        {

            //string[] locBits = new string[] { this.City, this.Region, this.PostalCode };

            System.Globalization.CultureInfo cul = System.Globalization.CultureInfo.CurrentCulture;
            string strUnknown = "UnknownLocation";

            string strLocation = string.Empty;
            if (args != null)
            {
                foreach (string s in args)
                    if (s != null && s.ToLower() != "none" && s != string.Empty)
                        strLocation += (strLocation == "") ? s : ", " + s;
            }
            return (strLocation == "") ? strUnknown : strLocation;
        }
    }
}
