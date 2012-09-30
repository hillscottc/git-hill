using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Data.Entity;
using log4net;

namespace MapTestConsole.GeoCoding
{
    public abstract class GeoCoderBase : IGeoCoder
    {

        public virtual ILog log
        {
            get{ throw new NotImplementedException(); }
        }
        
        //= LogManager.GetLogger(typeof(Program));

        public virtual GeoCodingProvider Provider
        {
            get { throw new NotImplementedException(); }
        }

        public virtual Uri UriRoot
        {
            get { throw new NotImplementedException(); }
        }

        protected virtual Uri GetQueryUri(string address)
        {
            throw new NotImplementedException();
        }

        public PlaceBase Query(string address)
        {
            if (string.IsNullOrEmpty(address))
            {
                throw new Exception("Address must not be a null or empty string.");
            }

            Uri queryUri = GetQueryUri(address);
            string response = new WebClient().DownloadString(queryUri);
            return ParseResponse(response);
        }

        public virtual PlaceBase ParseResponse(string response)
        {
            throw new NotImplementedException();
        }

        public bool ExistsInCache(string address, Models.ResultModelContainer dbContext)
        {
            return dbContext.VendorTestResults.Any(e => e.TestItem.Address == address);
        }

        public virtual void CachePlace(PlaceBase place, Models.ResultModelContainer dbContext)
        {
            throw new NotImplementedException();
        }



        
    }
}
