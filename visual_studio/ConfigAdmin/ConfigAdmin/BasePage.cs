using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ConfigAdmin
{
    /* Base page  funcs for the pages. */

    public class BasePage : System.Web.UI.Page
    {
        public string SemiColonToBr(object o)
        {
            if (o == null || o.Equals(DBNull.Value))
            {
                return String.Empty;
            }
            else
            {
                return ((string)o).Replace(";", "<br />");
            }
        }
    }
}