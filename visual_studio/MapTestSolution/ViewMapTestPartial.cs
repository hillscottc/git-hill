

namespace MapTestConsole
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
        private string getLocationString(params string[] args)
        {

            string[] locBits = new string[] { this.City, this.Region, this.PostalCode };

            System.Globalization.CultureInfo cul = System.Globalization.CultureInfo.CurrentCulture;
            string strUnknown = getResourceKeyValue("UnknownLocation");

            string strLocation = string.Empty;
            if (locBits != null)
            {
                foreach (string s in locBits)
                    if (s != null && s.ToLower() != NONE && s != string.Empty)
                        strLocation += (strLocation == "") ? s : ", " + s;
            }
            return (strLocation == "") ? strUnknown : strLocation;
        }

    }
}
