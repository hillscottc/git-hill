﻿using System;
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

        // for un-inited long and lat
        public const int NullValue = short.MinValue;

        private VendorTestResult(TestItem testItem, Vendor vendor) : base()
        {
            this.Vendor = vendor;
            this.TestItem = testItem;
            this.Latitude = NullValue;
            this.Longitude = NullValue;
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
                        //VendorTestResult testResult = new VendorTestResult(testItem.Id, vendor.Id);
                        VendorTestResult testResult = new VendorTestResult(testItem, vendor);
                        testResult.ProcessGeoCoding();
                        testResults.Add(testResult);
                        log.Info(String.Format("Address count: {0}, {1}", count.ToString(), testResult.ToString()));
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
                        log.Error(String.Format("Failed tested number {0} for {1}\n{2}", count, testItem.ToString(), e.ToString()));
                    }

                }

            }

            return testResults;
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
