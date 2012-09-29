using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.GeoCoding
{
    public class PlaceGoogle : PlaceBase
    {
        public string AccuracyLevel { get; set; }
        public string AccuracyDescription { get; set; }
        public string ResponseCode { get; set; }
        public string ResponseDescription { get; set; }
    }
}
