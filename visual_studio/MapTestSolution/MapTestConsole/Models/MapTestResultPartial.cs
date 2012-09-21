using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Geneva3.G3GeoMap;

namespace MapTestConsole.Models
{
    public partial class MapTestResult
    {
        /// <summary>
        /// Queries source the with and without zip, stores results.
        /// </summary>
        public void SetResults()
        {
            if (this.address == null || this.address == "")
                throw new ArgumentException("This object's address field must be set.");

            this.noZipAddress = GeoCodingOSM.StripTrailingPostalCode(address);

            QueryOSMWithZip();
            QueryOSMWithNOZip();

            this.distance = 0.00m;

            //double d = GeoMapUtil.distance((double)zipLatitude, (double)zipLongitude, (double)noZipLatitude, (double)noZipLongitude, 'M');
            if (zipLatitude != null && noZipLatitude != null)
            {
                float f = (float) GeoMapUtil.distance((double)zipLatitude, (double)zipLongitude, (double)noZipLatitude, (double)noZipLongitude, 'M');

                if ( ! float.IsNaN(f))
                {
                    this.distance = (decimal)Math.Round(f, 2);
                }
              
            }

        }

        private void QueryOSMWithZip()
        {
            GeoCodingOSM.Place place = GeoCodingOSM.GetCoordinates(this.address);
            if (place != null)
            {
                this.zipDisplay = place.DisplayName;
                this.zipLongitude = Decimal.Round(place.Longitude, 6);
                this.zipLatitude = Decimal.Round(place.Latitude, 6);
            }
        }

        private void QueryOSMWithNOZip()
        {
            GeoCodingOSM.Place place = GeoCodingOSM.GetCoordinates(this.noZipAddress);
            if (place != null)
            {
                this.noZipDisplay = place.DisplayName;
                this.noZipLongitude = Decimal.Round(place.Longitude, 6);
                this.noZipLatitude = Decimal.Round(place.Latitude, 6);
            }
        }

        public override string ToString()
        {
            //string s = string.Format("{0} {1}\n", address, zipDisplay);
            //s += string.Format("{0} {1}\n", noZipAddress, noZipDisplay);
            //s += "Distance between = " + distance;
            //return s;

            return address + "\n"
                + zipDisplay + "\n"
                + zipLongitude + " " + zipLatitude + "\n"
                + noZipAddress + "\n"
                + noZipDisplay + "\n"
                + noZipLongitude + " " + noZipLatitude + "\n"
                + "Distance between: " + distance.ToString();

        }



    }
}
