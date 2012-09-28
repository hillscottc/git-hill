using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Geneva3.G3GeoMap;

namespace MapTestConsole.Models
{
    public partial class VendorTestResult
    {
        // for un-inited long and lat
        public const int NullValue = short.MinValue;

        //public VendorTestResult(int testItemId, int vendorId) : base()
        //{
        //    //this.Vendor = vendor;
        //    this.VendorId = VendorId;
        //    //this.TestItem = testItem;
        //    this.TestItemId = testItemId;
        //    this.Latitude = NullValue;
        //    this.Longitude = NullValue;
        //}

        public VendorTestResult(TestItem testItem, Vendor vendor) : base()
        {
            this.Vendor = vendor;
            //this.VendorId = VendorId;
            this.TestItem = testItem;
            //this.TestItemId = testItemId;
            this.Latitude = NullValue;
            this.Longitude = NullValue;
        }

        public void ProcessGeoCoding()
        {
            if (this.Vendor == null || this.TestItem == null)
            {
                throw new ArgumentNullException("Vendor and TestItem unitialized.");
            }
        
            switch (Vendor.Name)
            {
                case "Google":
                    SearchGoogle(TestItem.Address);
                    break;
                case "OpenStreetMap":
                    SearchOSM(TestItem.Address);
                    break;
                case "OSMNoZip":
                    SearchOSM(GeoMapUtil.StripTrailingPostalCode(TestItem.Address));
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
                this.Longitude = (double) place.Longitude;
                this.Latitude = (double) place.Latitude;
            }
        }

        private void SearchGoogle(string address)
        {
            var coords = GeoCoding.GetCoordinates("http://webservices.geneva3.webvisible.com", address);
            if (coords != null)
            {
                this.Longitude = (double)coords.Longitude;
                this.Latitude = (double)coords.Latitude;
            }
        }

        public override string ToString()
        {
            return String.Format("Test Address:{0}; Vendor:{1}; Latitude:{2}; Longitude:{3} ", TestItem.Address, Vendor.Name, Latitude, Longitude);
        }

    }
}
