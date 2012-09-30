using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;
using log4net;

namespace MapTestConsole.GeoCoding
{
    public interface IGeoCoder
    {
        ILog log {get;}

        GeoCodingProvider Provider { get; }
        Uri UriRoot { get; }
        //Uri GetQueryUri(string address);

        /// <summary>
        /// Query provider with address to get 
        /// </summary>
        /// <param name="address"></param>
        /// <returns></returns>
        PlaceBase Query(string address);

        //PlaceBase ParseResponse(string response);
        PlaceBase ParseResponse(string response);

        bool ExistsInCache(string address, Models.ResultModelContainer dbContext);
        void CachePlace(PlaceBase place, Models.ResultModelContainer dbContext);
 
    }
}
