using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.GeoCoding
{
    public abstract class GeoCoderBase : IGeoCoder
    {
        public virtual GeoCodingProvider Provider
        {
            get { throw new NotImplementedException(); }
        }

        public virtual Uri RootUri
        {
            get { throw new NotImplementedException(); }
        }

        public virtual Uri GetQueryUri(string address)
        {
            throw new NotImplementedException();
        }

        public virtual string ApiKey
        {
            get { throw new NotImplementedException(); }
        }

        public virtual PlaceBase Query(string address)
        {
            throw new NotImplementedException();
        }

        public virtual void CachePlace(PlaceBase place)
        {
            throw new NotImplementedException();
        }

    }
}
