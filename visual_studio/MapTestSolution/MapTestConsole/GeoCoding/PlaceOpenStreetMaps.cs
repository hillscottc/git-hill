using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.GeoCoding
{
    public class PlaceOpenStreetMaps : PlaceBase
    {
        public long Id { get; set; }
        public int Rank { get; set; }
        public string BoundingBox { get; set; }
        public string DisplayName { get; set; }
        public string PlaceClass { get; set; }
        public string PlaceType { get; set; }
    }
}
