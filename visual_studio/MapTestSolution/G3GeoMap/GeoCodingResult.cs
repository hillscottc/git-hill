using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Geneva3.G3GeoMap
{
    public class GeoCodingResult
    {

        public GeoCodingResult()
        {

        }

        private decimal latitude;

        public decimal Latitude
        {
            get { return latitude; }
            set { latitude = value; }
        }
        private decimal longitude;

        public decimal Longitude
        {
            get { return longitude; }
            set { longitude = value; }
        }
        private int accuracyLevel;

        public int AccuracyLevel
        {
            get { return accuracyLevel; }
            set { accuracyLevel = value; }
        }
    }
}
