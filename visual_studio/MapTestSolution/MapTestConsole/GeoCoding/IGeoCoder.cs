using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using MapTestConsole.Models;
using log4net;

namespace MapTestConsole.GeoCoding
{
    public interface IGeoCoder
    {
        //ILog log {get;}
        GeoCodingProvider Provider { get; }
        Uri UriRoot { get; }
        VendorTestResult Query(TestItem testItem);
        PlaceBase ParseResponse(string response, string address);
        bool ExistsInCache(string address, Models.Vendor vendor);
        void CachePlace(PlaceBase place, Models.ResultModelContainer dbContext);
 
    }
}
