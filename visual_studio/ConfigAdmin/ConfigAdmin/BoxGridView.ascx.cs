using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ConfigAdmin
{
    public partial class BoxGridView : System.Web.UI.UserControl
    {
        public LinqDataSource LinqDataSource1;
 
        protected void Page_Load(object sender, EventArgs e)
        {

        }

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