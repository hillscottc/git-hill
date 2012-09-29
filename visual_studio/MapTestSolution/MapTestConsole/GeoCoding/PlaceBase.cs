using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.GeoCoding
{
    public class PlaceBase
    {
        public GeoCoordinates Coordinates { get; set; }
        public string QueryAddress { get; set; }
        public string AddressDisplay { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Region { get; set; }
        public string Country { get; set; }

    }
}
