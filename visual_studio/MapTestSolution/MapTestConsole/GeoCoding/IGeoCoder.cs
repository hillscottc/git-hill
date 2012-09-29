using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.GeoCoding
{
    public interface IGeoCoder
    {
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

        void CachePlace(PlaceBase place);
 
    }
}
