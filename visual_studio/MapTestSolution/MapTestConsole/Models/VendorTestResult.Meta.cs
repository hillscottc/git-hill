using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Geneva3.G3GeoMap;

namespace MapTestConsole.Models
{
    public partial class VendorTestResult : IVendorTestResult
    {

        public void SetResults(TestItem testItem, Vendor vendor)
        {
        
            this.VendorId = vendor.Id;
            this.TestItemId = testItem.Id;
          
            switch (vendor.Name)
            {
                case "Google":
                    SearchGoogle(testItem.Address);
                    break;
                case "OpenStreetMaps":
                    SearchOSM(testItem.Address);
                    break;
                default:
                    throw new ArgumentOutOfRangeException("Invalid search vendor.");
            }

        }

        private void SearchOSM(string address)
        {
            GeoCodingOSM.Place place = GeoCodingOSM.GetCoordinates(address);
            if (place != null)
            {
                //this.DisplayName = place.DisplayName;
                this.Longitude = Decimal.Round(place.Longitude, 6);
                this.Latitude = Decimal.Round(place.Latitude, 6);
            }
        }

        private void SearchGoogle(string address)
        {
            var coords = GeoCoding.GetCoordinates("http://webservices.geneva3.webvisible.com", address);
            if (coords != null)
            {
                this.Longitude = Decimal.Round(coords.Longitude, 6);
                this.Latitude = Decimal.Round(coords.Latitude, 6);
            }
        }


        //QueryOSMWithZip();
        //QueryOSMWithNOZip();

        //this.Distance = 0.00m;

        //double d = GeoMapUtil.distance((double)zipLatitude, (double)zipLongitude, (double)noZipLatitude, (double)noZipLongitude, 'M');
        //if (zipLatitude != null && noZipLatitude != null)
        //{
        //    float f = (float)GeoMapUtil.distance((double)zipLatitude, (double)zipLongitude, (double)noZipLatitude, (double)noZipLongitude, 'M');

        //    if (!float.IsNaN(f))
        //    {
        //        this.distance = (decimal)Math.Round(f, 2);
        //    }

        //}





        //private void QueryOSMWithZip()
        //{
        //    GeoCodingOSM.Place place = GeoCodingOSM.GetCoordinates(this.address);
        //    if (place != null)
        //    {
        //        this.zipDisplay = place.DisplayName;
        //        this.zipLongitude = Decimal.Round(place.Longitude, 6);
        //        this.zipLatitude = Decimal.Round(place.Latitude, 6);
        //    }
        //}

        //private void QueryOSMWithNOZip()
        //{
        //    GeoCodingOSM.Place place = GeoCodingOSM.GetCoordinates(this.noZipAddress);
        //    if (place != null)
        //    {
        //        this.noZipDisplay = place.DisplayName;
        //        this.noZipLongitude = Decimal.Round(place.Longitude, 6);
        //        this.noZipLatitude = Decimal.Round(place.Latitude, 6);
        //    }
        //}

        //public override string ToString()
        //{
        //    //string s = string.Format("{0} {1}\n", address, zipDisplay);
        //    //s += string.Format("{0} {1}\n", noZipAddress, noZipDisplay);
        //    //s += "Distance between = " + distance;
        //    //return s;


        //}
    }
}
