using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    interface IVendorTestResult
    {
        int Id { get; set; }
        int TestItemId { get; set; }
        int VendorId { get; set; }
        decimal Longitude { get; set; }
        decimal Latitude { get; set; }
        
        //void SetResults(string address, int firstVendor, int secondVendor);
    }
}
