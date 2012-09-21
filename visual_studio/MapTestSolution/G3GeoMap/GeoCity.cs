using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace Geneva3.G3GeoMap
{
    public class Coord
    {
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
    }

    public class GeoCity
    {
        public string Country { get; set; }
        public string RegionCode { get; set; }
        public string RegionName { get; set; }
        public string City { get; set; }
        public int? G3GeoID { get; set; }
        public string GoogleCode { get; set; }
        public Coord Coord { get; set; }

        public override string ToString()
        {
            return String.Format("{0}, {1}, {2}", City, RegionCode, Country);
        }
    }

    public class GeoCityComparer : IEqualityComparer<GeoCity>
    {
        #region IEqualityComparer<GeoCity> Members

        public bool Equals(GeoCity x, GeoCity y)
        {
            return x.G3GeoID == y.G3GeoID;
        }

        public int GetHashCode(GeoCity obj)
        {
            return obj.G3GeoID.GetHashCode();
        }

        #endregion
    }

    
}
