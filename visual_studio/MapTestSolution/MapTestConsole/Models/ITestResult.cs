using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    interface ITestResult
    {
        decimal Distance { get; set; }
        void SetResults(string address, int firstVendor, int secondVendor);
    }
}
