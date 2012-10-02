using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;
using log4net.Config;
using Geneva3.G3GeoMap;

namespace MapTestConsole.Models
{
    public partial class VendorTestResult
    {
        private static ILog log = LogManager.GetLogger(typeof(VendorTestResult));

        public VendorTestResult(GeoCoding.PlaceBase place, TestItem testItem, Vendor vendor)
        {
            Longitude = place.Coordinates.Longitude;
            Latitude = place.Coordinates.Latitude;
            TestItem = testItem;
            //TestItemId = testItem.Id;
            // avoiding a dup here..
           // Vendor = Models.Vendor.GetByName(vendor.Name);
            VendorId = vendor.Id;
        }

        private VendorTestResult(TestItem testItem, Vendor vendor) : base()
        {
            this.Vendor = vendor;
            this.TestItem = testItem;
            this.Latitude = GeoMapUtil.LatLngNullValue;
            this.Longitude = GeoMapUtil.LatLngNullValue;
        }

        public static IList<VendorTestResult> GetResultsForVendors(IList<TestItem> testItems, IList<Vendor> vendorList)
        {
            IList<VendorTestResult> testResults = new List<VendorTestResult>();

            int count = 0;

            foreach (TestItem testItem in testItems)
            {
                count++;

                foreach (Vendor vendor in vendorList)
                {
                    try
                    {
                        GeoCoding.GeoCoderBase geoCoder = GeoCoding.GeoCoderBase.GetGeoCoder(vendor);
                        VendorTestResult testResult = geoCoder.Query(testItem);
                        if (testResult != null)
                        {
                            testResults.Add(testResult);
                            log.Info(testResult);
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
                        log.Error(String.Format("TestItem...{0}\n  Error...{1}", testItem, e));
                    }

                }

            }

            return testResults;
        }

  

        public override string ToString()
        {
            return String.Format("{0}; testitemid:{1}; Latitude:{2}; Longitude:{3} ", VendorId, TestItemId, Latitude, Longitude);
        }

    }
}
